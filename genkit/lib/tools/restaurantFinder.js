"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.restaurantFinder = void 0;
const tool_1 = require("@genkit-ai/ai/tool");
const axios_1 = __importDefault(require("axios"));
const zod_1 = require("zod");
exports.restaurantFinder = (0, tool_1.defineTool)({
    name: 'restaurantFinder',
    description: `Used when needing to find a restaurant based on a users location.
      The location should be used to find nearby restaurants to a place. You can also
      selectively find restaurants based on the users preferences, but you should default
      to 'Local' if there are no indications of restaurant types in the users request.
      `,
    inputSchema: zod_1.z.object({ place: zod_1.z.string(), typeOfRestaurant: zod_1.z.string().optional() }),
    outputSchema: zod_1.z.unknown(),
}, async (input) => {
    if (input.typeOfRestaurant == undefined) {
        input.typeOfRestaurant = "Local";
    }
    const geocodeEndpoint = "https://places.googleapis.com/v1/places:searchText";
    const textQuery = { textQuery: `${input.typeOfRestaurant} restaurants in ${input.place}` };
    const response = await axios_1.default.post(geocodeEndpoint, JSON.stringify(textQuery), {
        headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": "AIzaSyCJIrZkGH04TIXcP2t8hvo97yKwGmwD-1k",
            "X-Goog-FieldMask": "places.displayName,places.formattedAddress,places.priceLevel,places.photos.name,places.editorialSummary,places.googleMapsUri"
        }
    });
    console.log(response.data);
    let data = response.data;
    for (let i = 0; i < data.places.length; i++) {
        if (data.places[i].photos) {
            data.places[i].photos = [data.places[i].photos[0]];
        }
    }
    return data;
});
//# sourceMappingURL=restaurantFinder.js.map