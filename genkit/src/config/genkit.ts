import { gemini15Pro, googleAI } from '@genkit-ai/googleai';
import { logger } from 'genkit/logging';
import { genkit } from 'genkit';
import { enableFirebaseTelemetry } from '@genkit-ai/firebase';
import { ChecksEvaluationMetricType, checksMiddleware } from '@genkit-ai/checks';
import { ModelMiddleware } from 'genkit/model';


enableFirebaseTelemetry();

export const ai = genkit({
    plugins: [
        googleAI(),

    ],
    model: gemini15Pro,
    promptDir: 'prompts',
})

logger.setLogLevel('debug');

const useChecksMiddleware = false;

export const myMiddleware: ModelMiddleware[] = [];

if (useChecksMiddleware) {
    myMiddleware.push(checksMiddleware({
        authOptions: {
          // Project to charge quota to.
          // Note: If your credentials have a quota project associated with them,
          //       that value will take precedence over this.
        //   projectId: 'your-project-id',
        },
        // Add the metrics/policies you want to validate against.
        metrics: [
          // This will use the default threshold determined by Checks.
          ChecksEvaluationMetricType.DANGEROUS_CONTENT,
          // This is how you can override the default threshold.
          {
            type: ChecksEvaluationMetricType.VIOLENCE_AND_GORE,
            // If the content scores above 0.55, it fails and the response will be blocked.
            threshold: 0.55,
          },
        ],
      })
    )
}