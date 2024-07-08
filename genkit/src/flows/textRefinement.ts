import { prompt } from "@genkit-ai/dotprompt";
import { defineFlow } from "@genkit-ai/flow";
import { z } from "zod";

// FINAL STEP
// We realize that our initial prompts aren't great, so we want to
// use a refinement step to prompt the user to provide more information.
// We can fill in this flow to get that additional information from the uesr.

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