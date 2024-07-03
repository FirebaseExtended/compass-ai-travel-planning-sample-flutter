import { getPlace } from "@compass/backend";
import { prompt } from "@genkit-ai/dotprompt";
import { defineFlow, run } from "@genkit-ai/flow";
import { z } from "zod";
import { dataConnectInstance } from "../config/firebase";
import { Destination } from "../common/types";
import { tripPlan2 } from "./shared/tripPlan";

export const placeRefinement = defineFlow(
    {
      name: 'placeRefinement',
      inputSchema: z.object({
        request: z.string(),
        placeRef: z.string(),
      }),
      outputSchema: z.unknown(),
    },
    async (userRequest) => {
        const location = await run(`getLocationFromRef-${userRequest.placeRef}`, async (): Promise<Destination> => {
            const location = getPlace(dataConnectInstance, {placeId: userRequest.placeRef as any});
            return (await location).data.place as Destination;
        });
        return await run(`refineTripTo-${userRequest.placeRef}`, async () => {
            return await tripPlan2(userRequest.request, location);
        });

        /**
         * How many people are coming?
         * Intensity range of activities?
         * Stepper value
         * 
         * Add in language codes and language detection for prompts and output
         * 
         *  */
});