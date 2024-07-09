"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.tripPlan2 = void 0;
const backend_1 = require("@compass/backend");
const firebase_1 = require("../../config/firebase");
const restaurantFinder_1 = require("../../tools/restaurantFinder");
const dotprompt_1 = require("@genkit-ai/dotprompt");
const axios_1 = __importDefault(require("axios"));
const MAPS_API_KEY = process.env.MAPS_API_KEY;
const getPlaceActivities = async (placeID) => {
    const result = await (0, backend_1.getActivitiesForPlace)(firebase_1.dataConnectInstance, { placeId: placeID });
    const locationActivies = result.data.activities;
    const activityDescs = locationActivies.map((value) => {
        return `{Name: ${value.name} Activity: ${value.description} Location: ${value.locationName}, timeofday: ${value.timeOfDay}, price: ${value.price}, familyFriendly: ${value.familyFriendly}, duration: ${value.duration}}, ref: ${value.ref}`;
    });
    return activityDescs;
};
const generateItineraryForPlace = async (request, location, activityDescs, rFormatted) => {
    const itineraryPrompt = await (0, dotprompt_1.prompt)('itineraryGenToolPico');
    const result = await itineraryPrompt.generate({
        input: {
            request: request,
            place: location.name,
            placeDescription: location.knownFor,
            activities: activityDescs,
            restaurants: rFormatted,
        }
    });
    return result.output();
};
/**
 * Exchange Photo URI exchanges the resource URI with a resolved photo locaiton
 * so we can help prevent accidental Google Maps API key leakage to the client
 * and we return a default uri if non is resolved for cases that we get a
* fictional uri endpoint.
* @param photoUri - URI of the Google Maps photo
* @returns a Promise to the string url
*/
const exchangePhotoUri = (photoUri) => {
    const exchangeUrl = `https://places.googleapis.com/v1/${photoUri}/media?maxHeightPx=400&maxWidthPx=400&key=${MAPS_API_KEY}&skipHttpRedirect=true`;
    let url = new Promise((resolve, reject) => {
        axios_1.default.get(exchangeUrl)
            .then((result) => {
            resolve(result.data.photoUri);
        })
            .catch((e) => {
            console.log("Cannot find Photo URI, using default URI");
            resolve("https://storage.googleapis.com/compass-imgs/default/dinerDefault.png");
        });
    });
    return url;
};
const formatPhoto = async (activityRef, locationRef, photoUri) => {
    if (photoUri != undefined && photoUri != "") {
        return exchangePhotoUri(photoUri);
    }
    return `https://storage.googleapis.com/compass-imgs/activities/${locationRef}_${activityRef}.jpg`;
};
/**
 * This searchs for restauruants that match the users preference for dinner.
 *
 * @param locationName - the location to search for restaurants
 * @param request - The specific user request
 * @returns Promise<string> a formatted array of any restaurants that match uesrs preference. Can sometimes be an empty array.
 */
const restaurantSearch = async (locationName, request) => {
    // TODO: Have the user fill this in.
    // Search for restaurants
    const finder = await (0, dotprompt_1.prompt)('formatRestaurantsQuery');
    const rresult = await finder.generate({
        input: {
            place: locationName,
            request: request,
        },
        returnToolRequests: true
    });
    // TODO: We are using tool usage here in a contrived example.
    const rOut = await Promise.all(rresult.toolRequests().map(async (element) => await (0, restaurantFinder_1.restaurantFinder)(element.toolRequest.input)));
    let rFormatted = [];
    if (rOut.length > 0) {
        rFormatted = rOut[0].places.map((value) => {
            return `{ displayName: ${value.displayName.text}, formattedAddress: ${value.formattedAddress}, googleMapsUri: ${value.googleMapsUri}, priceLevel: ${value.priceLevel}, photoUri: ${value.photos ? value.photos[0].name : ""}, "editorialSummary": ${value.editorialSummary ? value.editorialSummary.text : '""'} }`;
        });
    }
    return rFormatted;
};
/**
 * This cleans the output from the itinerary generator so its easier to consume.
 *
 * @param output The output of the generated itinerary
 * @param locationImgUrl The imgUrl for the location selected
 * @param locationRef The ref identifier for the location selected
 * @returns
 */
const cleanUpGeneratedItinerary = async (output, locationImgUrl, locationRef) => {
    output.itineraryImageUrl = locationImgUrl;
    output.placeRef = locationRef;
    for (var i = 0; i < output.itinerary.length; i++) {
        const dayPlan = output.itinerary[i].planForDay;
        for (var j = 0; j < dayPlan.length; j++) {
            dayPlan[j].imgUrl = await formatPhoto(dayPlan[j]['activityRef'], locationRef, dayPlan[j].photoUri);
        }
    }
    // console.log("TRIP NAME : \n\n\n\n\n\n\n\n\n\n", output.place);
    return output;
};
/**
 * Generates a trip plan based on the users request and the users destination.
 * The destination must exist in the database as it will fetch the activities
 * for that location from the database.
 *
 * @param request - A types of activities a user wants to do
 * @param location - The location the user wants to explore
 * @returns
 */
const tripPlan2 = async (request, location) => {
    const activityDescs = await getPlaceActivities(location.ref);
    let restaurants = [];
    if (MAPS_API_KEY) {
        restaurants = await restaurantSearch(location.name, request);
    }
    let result;
    // retry request, otherwise, throw an error
    try {
        result = await generateItineraryForPlace(request, location, activityDescs, restaurants);
    }
    catch (e) {
        result = await generateItineraryForPlace(request, location, activityDescs, restaurants);
    }
    console.log(result.place);
    return cleanUpGeneratedItinerary(result, location.imageUrl, location.ref);
};
exports.tripPlan2 = tripPlan2;
//# sourceMappingURL=tripPlan.js.map