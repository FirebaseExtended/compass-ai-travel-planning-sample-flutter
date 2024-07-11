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
exports.ItineraryRequest = void 0;
const zod_1 = require("zod");
exports.ItineraryRequest = zod_1.z.object({
    request: zod_1.z.string(),
    images: zod_1.z.array(zod_1.z.string()).optional(),
});
//# sourceMappingURL=types.js.map