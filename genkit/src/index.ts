import { configureGenkit } from '@genkit-ai/core';
import { startFlowsServer } from '@genkit-ai/flow';
import { vertexAI, claude3Opus, claude3Sonnet } from '@genkit-ai/vertexai';
import { firebase } from '@genkit-ai/firebase';
import { dotprompt } from '@genkit-ai/dotprompt';

// importing our own tooling.
import * as tools from './tools'
import * as flows from './flows'
import * as retrievers from './retrievers';
import { googleAI } from '@genkit-ai/googleai';
import { firebaseConfig } from './config/firebase';
import googleCloud from '@genkit-ai/google-cloud';
import { AlwaysOnSampler } from '@opentelemetry/sdk-trace-base';

configureGenkit({
  plugins: [
    firebase({
      flowStateStore: { collection: 'flowTraceStore' },
    }),
    vertexAI({
      modelGardenModels: [claude3Opus, claude3Sonnet],
      location: 'us-central1',
    }),
    dotprompt({ dir: 'prompts' }),
    googleAI({apiKey: firebaseConfig.apiKey}),
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
