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
import { tripPlan2 } from './shared/tripPlan';

export const itineraryGenerator2 = defineFlow(
    {
      name: 'itineraryGenerator2',
      inputSchema: ItineraryRequest,
      outputSchema: z.unknown(),
    },
    async (tripDetails) => {
      console.log("RUNNING");
      const placeDescription = await run('getPlaceDescription', async () => {
        if (!tripDetails.images || tripDetails.images.length === 0 || tripDetails.images[0] == "") {
          return '';
        }
        const imgDescription = await prompt('imgDesc');
        const result = await imgDescription.generate({
          input: { images: tripDetails.images },
        });
        return result.text();
      });
      const location = await run('determineLocation', async () => {
        const docs = await retrieve({
          retriever: placeRetriever,
          query: `Given the following information about a location, determine which location matches this description : ${placeDescription} ${tripDetails.request}`,
          options: {
            k: 3,
          },
        });
        let v: Array<Destination> = new Array();
        docs.forEach((doc) => {
          v.push({
            knownFor: doc.toJSON().content[0].text!,
            ref: doc.toJSON().metadata!.ref,
            country: doc.toJSON().metadata!.country,
            continent: doc.toJSON().metadata!.continent,
            imageUrl: doc.toJSON().metadata!.imageUrl,
            tags: doc.toJSON().metadata!.tags,
            name: doc.toJSON().metadata!.name,
          });
        });
        return v;
      });
      let locDetails: Promise<unknown>[] = [];
      for (let i = 0; i < location.length; i++) {
        const loc0 = run(`Details of place`, (): Promise<unknown> => {
            return tripPlan2(tripDetails.request!, location[i]);
          });
          locDetails.push(loc0);
      }
      
      const allTogether = await run('allTogether', async () => {
        const results = await Promise.all(locDetails);
        const itineraries = { itineraries: [...(results as ItineraryGeneratorOutput[])] };
        return itineraries;
      });
  
      return allTogether;
    },
  );