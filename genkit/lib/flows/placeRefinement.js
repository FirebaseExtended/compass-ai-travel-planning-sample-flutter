"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.placeRefinement = void 0;
const backend_1 = require("@compass/backend");
const flow_1 = require("@genkit-ai/flow");
const zod_1 = require("zod");
const firebase_1 = require("../config/firebase");
const tripPlan_1 = require("./shared/tripPlan");
exports.placeRefinement = (0, flow_1.defineFlow)({
    name: 'placeRefinement',
    inputSchema: zod_1.z.object({
        request: zod_1.z.string(),
        placeRef: zod_1.z.string(),
    }),
    outputSchema: zod_1.z.unknown(),
}, async (userRequest) => {
    const location = await (0, flow_1.run)(`getLocationFromRef-${userRequest.placeRef}`, async () => {
        const location = (0, backend_1.getPlace)(firebase_1.dataConnectInstance, { placeId: userRequest.placeRef });
        return (await location).data.place;
    });
    return await (0, flow_1.run)(`refineTripTo-${userRequest.placeRef}`, async () => {
        return await (0, tripPlan_1.tripPlan2)(userRequest.request, location);
    });
    /**
     * How many people are coming?
     * Intensity range of activities?
     * Stepper value
     *
     * Add in language codes and language detection for prompts and output
     *
     *  */
});
//# sourceMappingURL=placeRefinement.js.map