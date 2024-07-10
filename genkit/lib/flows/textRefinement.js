"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.textRefinement = void 0;
const dotprompt_1 = require("@genkit-ai/dotprompt");
const flow_1 = require("@genkit-ai/flow");
const zod_1 = require("zod");
// FINAL STEP
// We realize that our initial prompts aren't great, so we want to
// use a refinement step to prompt the user to provide more information.
// We can fill in this flow to get that additional information from the uesr.
// [START text_refinement_flow]
exports.textRefinement = (0, flow_1.defineFlow)({
    name: 'textRefinement',
    inputSchema: zod_1.z.string(),
    outputSchema: zod_1.z.unknown(),
}, async (userRequest) => {
    console.log("RUNNING REFINMENT");
    const refinementPrompt = await (0, dotprompt_1.prompt)('textRefinement');
    const result = await refinementPrompt.generate({
        input: {
            request: userRequest
        },
    });
    return result.output();
});
// [END text_refinement_flow]
//# sourceMappingURL=textRefinement.js.map