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

import { z } from 'genkit';

export interface PlaceResponse {
    places: Place[],
  }
  
export interface Place {
    formattedAddress: string,
    googleMapsUri: string,
    priceLevel: string,
    displayName: LocalizedText,
    editorialSummary: LocalizedText,
    photos: [{name:string}],
  }

export interface LocalizedText {
    text:String,
    languageCode:string
  }

export interface Destination {
    ref:string,
    name: string,
    country: string,
    continent: string,
    knownFor: string,
    tags: string[],
    imageUrl: string,
}
  
export interface ActivitiesRoot {
    activities: Activity[];
}
  
export interface Activity {
    duration: number;
    timeOfDay: string;
    locationName: string;
    familyFriendly: boolean;
    destinationRef: string;
    ref: string;
    name: string;
    price: number;
    imageUrl: string;
    description: string;
}

export interface MyResult {
    itineraries: Destination[];
  }

export const ItineraryRequest = z.object({
    request: z.string(),
    images: z.array(z.string()).optional(),
});

export interface PlanForDay {
    activityRef: string,
    activityTitle: string,
    activityDesc: string,
    photoUri?: string,
    googleMapsUri?: string,
    imgUrl?: string,
}

export interface Itinerary {
    day: number
    date: string
    planForDay: PlanForDay[]
}

export interface ItineraryGeneratorOutput {
    place: string,
    itineraryName: string,
    startDate: string,
    endDate: string,
    tags: string[],
    itinerary: Itinerary[],
    itineraryImageUrl?: string,
    placeRef?: string,
}