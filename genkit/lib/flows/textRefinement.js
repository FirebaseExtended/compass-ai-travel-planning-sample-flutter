/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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