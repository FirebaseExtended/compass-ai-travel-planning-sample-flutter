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

import { getNearestPlace } from '@compass/backend';
import { Destination } from '../common/types';
import { z } from 'genkit';
import { dataConnectInstance } from '../config/firebase';
import { textEmbeddingGecko001 } from '@genkit-ai/googleai';
import { ai } from '../config/genkit';
import { Document } from 'genkit';

export const QueryOptions = z.object({
    k: z.number().optional(),
  });

/**
 * placeRetriever is used to retrieve results from a storage system.
 * In our case, the storage system is Firebase Data Connect.
 * We are using the generated client SDKs for now, but once the admin
 * SDKs are available, we would likely prefer to use those.
 */
export const placeRetriever = ai.defineRetriever(
    {
      name: 'dataconnect-placeRetriever',
      configSchema: QueryOptions,
    },
    async (input, options) => {
      const requestEmbedding = await ai.embed({
        embedder: textEmbeddingGecko001,
        content: input.text,
      });
      const result = await getNearestPlace(
        dataConnectInstance, 
        { placeDescriptionVector: requestEmbedding }
      );
      
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