import { prompt } from "@genkit-ai/dotprompt";
import { defineFlow } from "@genkit-ai/flow";
import { z } from "zod";

export const textRefinement = defineFlow(
    {
      name: 'textRefinement',
      inputSchema: z.string(),
      outputSchema: z.unknown(),
    },
    async (userRequest) => {
        const refinementPrompt = await prompt('textRefinement')
        const result = await refinementPrompt.generate({
            input: {
                request: userRequest
            },
        });
        return result.output();
});