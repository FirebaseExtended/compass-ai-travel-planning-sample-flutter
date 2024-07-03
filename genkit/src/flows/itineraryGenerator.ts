import { retrieve } from '@genkit-ai/ai/retriever';
import { prompt } from '@genkit-ai/dotprompt';
import { defineFlow, run } from "@genkit-ai/flow";
import { z } from "zod";
import { placeRetriever } from '../retrievers/placeRetriever';
import { Destination, ItineraryGeneratorOutput, ItineraryRequest } from '../common/types';
import { tripPlan2 } from './shared/tripPlan';
import { translatedRequest } from './shared/translation';

export const itineraryGenerator2 = defineFlow(
    {
      name: 'itineraryGenerator2',
      inputSchema: ItineraryRequest,
      outputSchema: z.unknown(),
    },
    async (tripDetails) => {
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
        // We need the english version of the request for better embedding support.
        const enRequest = await translatedRequest(tripDetails.request);
        const docs = await retrieve({
          retriever: placeRetriever,
          query: `Given the following information about a location, determine which location matches this description : ${placeDescription} ${enRequest}`,
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