import { gemini15Pro, googleAI } from '@genkit-ai/googleai';
import { logger } from 'genkit/logging';
import { genkit } from 'genkit';
import { enableGoogleCloudTelemetry } from '@genkit-ai/google-cloud';

export const ai = genkit({
    plugins: [
        googleAI(),

    ],
    model: gemini15Pro,
    promptDir: 'prompts',
})

logger.setLogLevel('debug');

enableGoogleCloudTelemetry();