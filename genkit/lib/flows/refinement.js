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