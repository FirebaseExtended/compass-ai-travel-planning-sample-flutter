import { configureGenkit } from '@genkit-ai/core';
import { startFlowsServer } from '@genkit-ai/flow';
import { vertexAI } from '@genkit-ai/vertexai';
import { firebase } from '@genkit-ai/firebase';
import { googleAI } from '@genkit-ai/googleai';
import { dotprompt } from '@genkit-ai/dotprompt';

// importing our own tooling.
import * as tools from './tools'
import * as flows from './flows'
import * as retrievers from './retrievers';
import googleCloud from '@genkit-ai/google-cloud';
import { AlwaysOnSampler } from '@opentelemetry/sdk-trace-base';

configureGenkit({
  plugins: [
    firebase({
      flowStateStore: { collection: 'flowTraceStore' },
    }),
    googleAI(),
    // Uncomment to use Vertex AI instead.
    // vertexAI({
    //   location: 'us-central1',
    // }),
    dotprompt({ dir: 'prompts' }),
    googleCloud({
      forceDevExport: true, // Set this to true to export telemetry for local runs
      telemetryConfig: {
        sampler: new AlwaysOnSampler(),
        autoInstrumentation: true,
        autoInstrumentationConfig: {
          '@opentelemetry/instrumentation-fs': { enabled: false },
          '@opentelemetry/instrumentation-dns': { enabled: false },
          '@opentelemetry/instrumentation-net': { enabled: false },
        },
        metricExportIntervalMillis: 5_000,
        metricExportTimeoutMillis: 5_000,
      },
    }),
  ],
  flowStateStore: 'firebase',
  traceStore: 'firebase',
  enableTracingAndMetrics: true,
  logLevel: 'debug',
  telemetry: {
    instrumentation: 'googleCloud',
    logger: 'googleCloud',
  },
});

// Making our tooling discoverable as endpoints to the flow server.
export {tools, flows, retrievers};

startFlowsServer();
