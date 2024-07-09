import { defineTool } from "@genkit-ai/ai/tool";
import axios from "axios";
import { z } from "zod";
import { PlaceResponse } from "../common/types";

// TODO: Have this tool be empty but supply the content of it.
// The description should be something an LLM can understand as a prompt.
// Then we call the places API.

export const restaurantFinder = defineTool(
  // [START restaurant_tool_desc]  
    {  
      name: 'restaurantFinder',
      description: `Used when needing to find a restaurant based on a users location.
      The location should be used to find nearby restaurants to a place. You can also
      selectively find restaurants based on the users preferences, but you should default
      to 'Local' if there are no indications of restaurant types in the users request.
      `,
      inputSchema: z.object({ place: z.string(), typeOfRestaurant: z.string().optional() }),
      outputSchema: z.unknown(),
    },
    // [END restaurant_tool_desc]
    // [START restaurant_tool_func]
    async (input) => {
      const MAPS_API_KEY = process.env.MAPS_API_KEY;
      
        if (input.typeOfRestaurant == undefined) {
          input.typeOfRestaurant = "Local";
        }
        const geocodeEndpoint = "https://places.googleapis.com/v1/places:searchText";
        const textQuery = {textQuery: `${input.typeOfRestaurant} restaurants in ${input.place}`};
  
        const  response = await axios.post(
          geocodeEndpoint,
          JSON.stringify(textQuery),
          {
            headers: {
              "Content-Type": "application/json",
              "X-Goog-Api-Key": MAPS_API_KEY,
              "X-Goog-FieldMask": "places.displayName,places.formattedAddress,places.priceLevel,places.photos.name,places.editorialSummary,places.googleMapsUri"
            }
          }
        );
        console.log(response.data);
        let data = (response.data as PlaceResponse);
        for(let i = 0; i < data.places.length; i++) {
          if (data.places[i].photos) {
            data.places[i].photos = [data.places[i].photos[0]];
          }
        }
        return data as PlaceResponse;
    }
    // [END restaurant_tool_func]
  );