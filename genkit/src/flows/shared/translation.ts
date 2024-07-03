import { run } from "@genkit-ai/flow";
import { Translate } from "@google-cloud/translate/build/src/v2";

export const determineRequestLanguage = async (request: string): Promise<string> => {
    return await run(`determineRequestLanguage`, async (): Promise<string> => {
        const {Translate} = require('@google-cloud/translate').v2;
        const translate: Translate = new Translate({});

        let [detections] = await translate.detect(request)
        if (Array.isArray(detections)) {
            detections = detections[0];
        }
        return detections.language;
    });
}

export const translatedRequest = async (originalRequest: string): Promise<string> => {
    return await run('translateRequest', async (): Promise<string> => {
      const requestLanguage = await determineRequestLanguage(originalRequest);
      if (requestLanguage == "en") {
        return originalRequest
      }
      const translate: Translate = new Translate();
  
      let [translations] = await translate.translate(originalRequest, {to: "en", from: requestLanguage});
      return translations;
    });
  }