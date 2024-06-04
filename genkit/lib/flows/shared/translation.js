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
exports.translatedRequest = exports.determineRequestLanguage = void 0;
const flow_1 = require("@genkit-ai/flow");
const v2_1 = require("@google-cloud/translate/build/src/v2");
const determineRequestLanguage = async (request) => {
    return await (0, flow_1.run)(`determineRequestLanguage`, async () => {
        const { Translate } = require('@google-cloud/translate').v2;
        const translate = new Translate({});
        let [detections] = await translate.detect(request);
        if (Array.isArray(detections)) {
            detections = detections[0];
        }
        return detections.language;
    });
};
exports.determineRequestLanguage = determineRequestLanguage;
const translatedRequest = async (originalRequest) => {
    return await (0, flow_1.run)('translateRequest', async () => {
        const requestLanguage = await (0, exports.determineRequestLanguage)(originalRequest);
        if (requestLanguage == "en") {
            return originalRequest;
        }
        const translate = new v2_1.Translate();
        let [translations] = await translate.translate(originalRequest, { to: "en", from: requestLanguage });
        return translations;
    });
};
exports.translatedRequest = translatedRequest;
//# sourceMappingURL=translation.js.map