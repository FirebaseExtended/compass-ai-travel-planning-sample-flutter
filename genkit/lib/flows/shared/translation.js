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