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

import { configureGenkit } from '@genkit-ai/core';
import { startFlowsServer } from '@genkit-ai/flow';
import { vertexAI } from '@genkit-ai/vertexai';
import { googleAI } from '@genkit-ai/googleai';
import { dotprompt } from '@genkit-ai/dotprompt';

// importing our own tooling.
import * as tools from './tools'
import * as flows from './flows'
import * as retrievers from './retrievers';

configureGenkit({
  plugins: [
    googleAI(),
    // Uncomment to use Vertex AI instead.
    // vertexAI({
    //   location: 'us-central1',
    // }),
    dotprompt({ dir: 'prompts' }),
  ],
  enableTracingAndMetrics: true,
  logLevel: 'debug',
});

// Making our tooling discoverable as endpoints to the flow server.
export {tools, flows, retrievers};

startFlowsServer({port: 2222, cors: {
  origin: "*",
}});
