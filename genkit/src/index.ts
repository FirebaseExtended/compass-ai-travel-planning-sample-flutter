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
