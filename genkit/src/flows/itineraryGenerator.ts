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

import { retrieve } from '@genkit-ai/ai/retriever';
import { prompt } from '@genkit-ai/dotprompt';
import { defineFlow, run } from "@genkit-ai/flow";
import { z } from "zod";
import { placeRetriever } from '../retrievers/placeRetriever';
import { Destination, ItineraryGeneratorOutput, ItineraryRequest } from '../common/types';
import { planItenerary } from './shared/tripPlan';

export const itineraryGenerator2 = defineFlow(
    {
      name: 'itineraryGenerator2',
      inputSchema: ItineraryRequest,
      outputSchema: z.unknown(),
    },
    async (tripDetails) => {
      console.log("RUNNING");

      // #region : 1 - Obtain the description of the image
      const imageDescription = await run('Decribe Image', async () => {
        if (!tripDetails.images || tripDetails.images.length === 0 || tripDetails.images[0] == "") {
          return '';
        }
        const imgDescription = await prompt('imageDescription');
        const result = await imgDescription.generate({
          input: { images: tripDetails.images },
        });
        return result.text();
      });

      // #endregion : 1 - Obtain the description of the image

      // #region : 2 - Suggest Destinations matching users input
      const possibleDestinations = await run('Suggest Destinations', async () => {

        // #region : Retriever
        const contextDestinations = await retrieve({
          retriever: placeRet`riever,
          query: `${imageDescription} ${tripDetails.request}`,
          options: {
            k: 3,
          },
        });
        // #endregion

        const suggestDestinationsAgentPrompt = await prompt('suggestDestinationsWithContextAgent');
        const result = await suggestDestinationsAgentPrompt.generate({
          input: { description: `${imageDescription} ${tripDetails.request}` },
          context: contextDestinations
        });

        const { destinations } = result.output() as { destinations: Destination[] };

        // #region : Clean Up images
        destinations.forEach((dest) =>{
            const doc1 = contextDestinations.find((doc) => doc.toJSON().metadata!.ref === dest.ref)
            if(doc1){
              dest.imageUrl = doc1.toJSON().metadata!.imageUrl;
            }
        });
        // #endregion

        return destinations;

      });

     // #region : 3 - Plan itineraries for each destination
     let destDetails: Promise<unknown>[] = [];

     possibleDestinations.forEach((dest) => {
       const loc0 = run(`Plan Itinerary for Destination: `+ dest.ref , (): Promise<unknown> => {
         return planItenerary(tripDetails.request!, dest);
       });
       destDetails.push(loc0);
     });
     //#endregion


     // #region 4 - Merge eveything together and tide up data model
     const itineraries = await run('Finally Merge all Results into Itinerary', async () => {
       const results = await Promise.all(destDetails);
       const itineraries = { itineraries: [...(results as ItineraryGeneratorOutput[])] };
       return itineraries;
     });
     // #endregion
 
     return itineraries;
    },
  );