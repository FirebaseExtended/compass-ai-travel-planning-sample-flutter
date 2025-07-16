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

import { ModelResponseData } from "genkit";
import { GemmaResponse } from "./types";

const JSON_HEADER = '```json';
const JSON_FOOTER = '```';

export function parseGemmaResponseText(response: ModelResponseData): string {
    const gemmaResponse = response as GemmaResponse;
    if (!gemmaResponse.raw || !gemmaResponse.raw.text || typeof gemmaResponse.raw.text !== "function") {
        throw new Error('Unexpected Gemma response');
    }

    return gemmaResponse.raw.text();
}

// Gemma does not support JSON mode. Therefore, we attempt to parse the text as a JSON object.
// Even if no JSON mode is supported, we can tell Gemma to respect a JSON format, even if returned as text.
export function parseGemmaResponseAsJson(gemmaResponse: ModelResponseData): unknown {
    const text = parseGemmaResponseText(gemmaResponse);
    const jsonText = text.slice(JSON_HEADER.length, -JSON_FOOTER.length);
    return JSON.parse(jsonText);
}
