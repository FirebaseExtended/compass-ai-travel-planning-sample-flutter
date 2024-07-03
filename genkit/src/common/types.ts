import { z } from "zod";

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