import { Genkit, GenerateResponseData, GenerateRequest, Role } from "genkit";
import { ModelAction } from "genkit/model";
import { GenkitPlugin, genkitPlugin } from "genkit/plugin";
import { Content, createPartFromBase64, createPartFromText, GenerateContentResponse, GoogleGenAI} from "@google/genai";
import { GENAI } from './keys'

const PLUGIN_NAME = "vertexai-gemma";

interface GemmaModelOptions {
  name: string;
}

type GenkitFinishReason = "stop" | "length" | "blocked" | "interrupted" | "other" | "unknown";
type GenkitContent = {
  text: string;
};

function extractMimeTypeFromDataUri(dataUriString: string) {
  if (typeof dataUriString !== 'string' || !dataUriString.startsWith('data:')) {
    return null; // Not a valid Data URI string
  }

  // Find the end of the MIME type part, which is either ';' or ','
  const endOfMimeType = dataUriString.indexOf(';');
  const endOfMimeTypeOrData = dataUriString.indexOf(',');

  let mimeType;
  if (endOfMimeType !== -1 && endOfMimeType < endOfMimeTypeOrData) {
    // MIME type is followed by a semicolon (e.g., "data:image/png;base64")
    mimeType = dataUriString.substring(5, endOfMimeType); // 5 to skip "data:"
  } else if (endOfMimeTypeOrData !== -1) {
    // MIME type is followed directly by a comma (e.g., "data:image/png,iVBORw0KGgoAAAA...")
    mimeType = dataUriString.substring(5, endOfMimeTypeOrData); // 5 to skip "data:"
  } else {
    // No valid MIME type separator found
    return null;
  }

  // Convert to lowercase as MIME types are often treated case-insensitively,
  // but standard practice is lowercase.
  return mimeType.toLowerCase();
}

function getPartFromContent(content: any) {
  if (content.media) {
    const mimeType = extractMimeTypeFromDataUri(content.media.url);
    if (!mimeType) {
      throw new Error(`Invalid media URL: ${content.media.url}`);
    }

    const data = content.media.url.substring(content.media.url.indexOf(',') + 1);
    return createPartFromBase64(data, mimeType);
  }

  return createPartFromText(content.text);
}

function getContentsFromRequest(request: GenerateRequest): Content[] {
  return request.messages.map((message) => ({
    role: message.role,
    parts: message.content.map(content => getPartFromContent(content))
  }));
}

export function defineGemmaModel(
  ai: Genkit,
  options: GemmaModelOptions
): ModelAction {
  return ai.defineModel({
    name: `${PLUGIN_NAME}/options.name`,
  }, async (request) => {
    const modelName = options.name;
  
    const ai = new GoogleGenAI({ apiKey: GENAI });
    const response = await ai.models.generateContent({
      model: modelName,
      contents: getContentsFromRequest(request),
      config: request.config
    });

    return parseGemmaResponse(response);
  });
}

function parseGemmaResponse(response: GenerateContentResponse): GenerateResponseData {
  let role: Role | undefined = undefined;
  let finishReason: GenkitFinishReason = "unknown"
  const content: GenkitContent[] = [];
  for (const candidate of response.candidates ?? []) {
    if (finishReason === "unknown" && candidate.finishReason) {
      finishReason = candidate.finishReason === "STOP" ? "stop" : "other";
    }

    if (!role && candidate.content?.role) {
      role = candidate.content.role as Role;
    }

    for (const part of candidate.content?.parts ?? []) {
      if (!part.text) {
        continue;
      }
  
      content.push({
        text: part.text
      });
    }
  }

  return {
    message: {
      role: role ?? "model",
      content,
    },
    finishReason
  };
}
  
export function vertexAIGemmaModel(options: GemmaModelOptions): GenkitPlugin {
    return genkitPlugin(PLUGIN_NAME, async (ai: Genkit) => {
      defineGemmaModel(ai, options);
    });
}
