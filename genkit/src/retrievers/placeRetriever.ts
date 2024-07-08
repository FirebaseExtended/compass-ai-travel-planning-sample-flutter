import { getNearestPlace } from "@compass/backend";
import { defineRetriever, Document } from "@genkit-ai/ai/retriever";
import { Destination } from "../common/types";
import { z } from "zod";
import { dataConnectInstance } from "../config/firebase";

export const QueryOptions = z.object({
    k: z.number().optional(),
  });

/**
 * placeRetriever is used to retrieve results from a storage system.
 * In our case, the storage system is Firebase Data Connect.
 * We are using the generated client SDKs for now, but once the admin
 * SDKs are available, we would likely prefer to use those.
 */
export const placeRetriever = defineRetriever(
    {
      name: 'postgres-placeRetriever',
      configSchema: QueryOptions,
    },
    async (input, options) => {
      const result = await getNearestPlace(dataConnectInstance, { placeDescription: input.text() });
  
      const resultData = result.data;
      return {
        documents: resultData.places_embedding_similarity.map(
          (row: Destination) => {
            const { knownFor, ...metadata } = row;
            return Document.fromText(knownFor, metadata);
          },
        ),
      };
    },
  );