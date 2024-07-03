import { prompt } from "@genkit-ai/dotprompt";
import { defineFlow } from "@genkit-ai/flow";
import { z } from "zod";

export const refinement = defineFlow(
    {
      name: 'refinement',
      inputSchema: z.string(),
      outputSchema: z.unknown(),
    },
    async (userRequest) => {
        const refinementPrompt = await prompt('refinement')
        const result = await refinementPrompt.generate({
            input: {
                request: userRequest
            },
        });
        return result.output();
});