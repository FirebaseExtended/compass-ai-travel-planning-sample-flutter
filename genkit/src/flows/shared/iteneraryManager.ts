/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { getActivitiesForPlace } from '@compass/backend';
import { dataConnectInstance } from '../../config/firebase';
import { Activity, Destination, ItineraryGeneratorOutput, Place, PlaceResponse } from '../../common/types';
import { restaurantFinder } from '../../tools/restaurantFinder';
import { supermarketFinder } from '../../tools/supermarketFinder';
import axios from 'axios';
import { ai, myMiddleware } from '../../config/genkit';

const MAPS_API_KEY = process.env.MAPS_API_KEY;

const getPlaceActivities = async (placeID: string): Promise<string[]> => {
    const result = await getActivitiesForPlace(dataConnectInstance, {placeId: placeID});
    
    const locationActivies = result.data.activities;
    const activityDescs = locationActivies.map((value: Activity) => {
        return `{Name: ${value.name} Activity: ${value.description} Location: ${value.locationName}, timeofday: ${value.timeOfDay}, price: ${value.price}, familyFriendly: ${value.familyFriendly}, duration: ${value.duration}}, ref: ${value.ref}`;
    });
    return activityDescs;
  };

const generateItineraryForPlace = async (request: string, location: Destination, activityDescs: string[]):Promise<ItineraryGeneratorOutput> => {
    // #region : recommend Meals
    let mealPlaces: string[] = [];
    if (MAPS_API_KEY) {
        mealPlaces = await recommendMeals(location.name, request);
    }
    // #endregion
    
    const itineraryPlanningAgentPrompt = await ai.prompt('itineraryPlanningAgent');
    const itineraries = await itineraryPlanningAgentPrompt({
        request: request,
        place: location!.name,
        knownFor: location!.knownFor,
        activities: activityDescs,
        mealOptions: mealPlaces
    },{
        use: [...myMiddleware],
    });
    return itineraries.output as ItineraryGeneratorOutput;
}

/**
 * Exchange Photo URI exchanges the resource URI with a resolved photo locaiton
 * so we can help prevent accidental Google Maps API key leakage to the client
 * and we return a default uri if non is resolved for cases that we get a
* fictional uri endpoint.
* @param photoUri - URI of the Google Maps photo
* @returns a Promise to the string url
*/
const exchangePhotoUri = (photoUri: string): Promise<string> => {
    const exchangeUrl = `https://places.googleapis.com/v1/${photoUri}/media?maxHeightPx=400&maxWidthPx=400&key=${MAPS_API_KEY}&skipHttpRedirect=true`;
    let url = new Promise<string>((resolve, reject) => {
    axios.get(exchangeUrl)
        .then((result) => {
            resolve(result.data.photoUri);
        })
        .catch((e) => {
            console.log("Cannot find Photo URI, using default URI");
            resolve("https://storage.googleapis.com/compass-imgs/default/dinerDefault.png");
        })
    });
    return url;
}

const formatPhoto = async (activityRef: string, locationRef: string, photoUri?: string): Promise<string> => {
    if (photoUri != undefined && photoUri != "") {
        return exchangePhotoUri(photoUri);
    }
    return `https://storage.googleapis.com/compass-imgs/activities/${locationRef}_${activityRef}.jpg`;
}

/**
 * This searchs for restauruants that match the users preference for dinner.
 * 
 * @param locationName - the location to search for restaurants
 * @param request - The specific user request
 * @returns Promise<string> a formatted array of any restaurants that match uesrs preference. Can sometimes be an empty array.
 */
const recommendMeals = async (locationName: string, request: string): Promise<string[]> => {
    // TODO: Have the user fill this in.
    // Search for restaurants
    const mealsPlanningAgentPrompt = await ai.prompt('mealsPlanningAgent');

    const rescommendMealsTool = await mealsPlanningAgentPrompt({
        place: locationName,
        request: request,   
    }, {
        returnToolRequests: true,
        use: [...myMiddleware],
    });

    // TODO: We are using tool usage here in a contrived example.
    const restaurantsFound: PlaceResponse[] = await Promise.all(
        rescommendMealsTool.toolRequests.map(async (element) => {
            switch(element.toolRequest.name){
                case "restaurantFinder":
                    return await restaurantFinder(
                        element.toolRequest.input as any
                    ) as PlaceResponse;
                    break;
                case "supermarketFinder":
                    return await supermarketFinder(
                        element.toolRequest.input as any
                    ) as PlaceResponse;
                    break;
            }
            return await restaurantFinder(
                element.toolRequest.input as any
            ) as PlaceResponse;
        }
    ));

    let rFormatted: string[] = [];
    if (restaurantsFound.length>0) {
        rFormatted = restaurantsFound[0].places.map((value: Place) => {
            return `{ displayName: ${value.displayName.text}, formattedAddress: ${value.formattedAddress}, googleMapsUri: ${value.googleMapsUri}, priceLevel: ${value.priceLevel}, photoUri: ${value.photos ? value.photos[0].name : ""}, "editorialSummary": ${value.editorialSummary ? value.editorialSummary.text : '""'} }`
        });
    }
    return rFormatted;
}


/**
 * This cleans the output from the itinerary generator so its easier to consume.
 * 
 * @param output The output of the generated itinerary
 * @param locationImgUrl The imgUrl for the location selected
 * @param locationRef The ref identifier for the location selected
 * @returns 
 */
const cleanUpGeneratedItinerary = async (
    output: ItineraryGeneratorOutput,
    locationImgUrl: string,
    locationRef: string,
) => {
    output.itineraryImageUrl = locationImgUrl;
    output.placeRef = locationRef;
    for (var i = 0; i < output.itinerary.length; i++) {
        const dayPlan = output.itinerary[i].planForDay;
        for (var j = 0; j < dayPlan.length; j++) {
        dayPlan[j].imgUrl = await formatPhoto(
            dayPlan[j]['activityRef'],
            locationRef,
            dayPlan[j].photoUri,
            );
        }
    }
    return output;
}

/**
 * Generates a trip plan based on the users request and the users destination.
 * The destination must exist in the database as it will fetch the activities
 * for that location from the database.
 * 
 * @param request - A types of activities a user wants to do
 * @param location - The location the user wants to explore
 * @returns 
 */
export const planItenerary = async (request: string, location: Destination): Promise<ItineraryGeneratorOutput> => {
    
    // Activities RAG for each destination
    const activities= await getPlaceActivities(location.ref);

    let result: ItineraryGeneratorOutput;
    
    // retry request, otherwise, throw an error
    try {
        result = await generateItineraryForPlace(request, location, activities);
    } catch (e) {
        result = await generateItineraryForPlace(request, location, activities);
    }
    
    return cleanUpGeneratedItinerary(result, location.imageUrl, location.ref);
};