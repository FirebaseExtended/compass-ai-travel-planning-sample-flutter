"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.refinement = void 0;
const dotprompt_1 = require("@genkit-ai/dotprompt");
const flow_1 = require("@genkit-ai/flow");
const zod_1 = require("zod");
exports.refinement = (0, flow_1.defineFlow)({
    name: 'refinement',
    inputSchema: zod_1.z.string(),
    outputSchema: zod_1.z.unknown(),
}, async (userRequest) => {
    const refinementPrompt = await (0, dotprompt_1.prompt)('refinement');
    const result = await refinementPrompt.generate({
        input: {
            request: userRequest
        },
    });
    return result.output();
});
//# sourceMappingURL=refinement.js.map