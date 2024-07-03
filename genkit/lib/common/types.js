"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ItineraryRequest = void 0;
const zod_1 = require("zod");
exports.ItineraryRequest = zod_1.z.object({
    request: zod_1.z.string(),
    images: zod_1.z.array(zod_1.z.string()).optional(),
});
//# sourceMappingURL=types.js.map