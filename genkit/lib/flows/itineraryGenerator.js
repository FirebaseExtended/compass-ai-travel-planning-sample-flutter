"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.itineraryGenerator2 = void 0;
const retriever_1 = require("@genkit-ai/ai/retriever");
const dotprompt_1 = require("@genkit-ai/dotprompt");
const flow_1 = require("@genkit-ai/flow");
const zod_1 = require("zod");
const placeRetriever_1 = require("../retrievers/placeRetriever");
const types_1 = require("../common/types");
const tripPlan_1 = require("./shared/tripPlan");
const translation_1 = require("./shared/translation");
exports.itineraryGenerator2 = (0, flow_1.defineFlow)({
    name: 'itineraryGenerator2',
    inputSchema: types_1.ItineraryRequest,
    outputSchema: zod_1.z.unknown(),
}, async (tripDetails) => {
    const placeDescription = await (0, flow_1.run)('getPlaceDescription', async () => {
        if (!tripDetails.images || tripDetails.images.length === 0 || tripDetails.images[0] == "") {
            return '';
        }
        const imgDescription = await (0, dotprompt_1.prompt)('imgDesc');
        const result = await imgDescription.generate({
            input: { images: tripDetails.images },
        });
        return result.text();
    });
    const location = await (0, flow_1.run)('determineLocation', async () => {
        // We need the english version of the request for better embedding support.
        const enRequest = await (0, translation_1.translatedRequest)(tripDetails.request);
        const docs = await (0, retriever_1.retrieve)({
            retriever: placeRetriever_1.placeRetriever,
            query: `Given the following information about a location, determine which location matches this description : ${placeDescription} ${enRequest}`,
            options: {
                k: 3,
            },
        });
        let v = new Array();
        docs.forEach((doc) => {
            v.push({
                knownFor: doc.toJSON().content[0].text,
                ref: doc.toJSON().metadata.ref,
                country: doc.toJSON().metadata.country,
                continent: doc.toJSON().metadata.continent,
                imageUrl: doc.toJSON().metadata.imageUrl,
                tags: doc.toJSON().metadata.tags,
                name: doc.toJSON().metadata.name,
            });
        });
        return v;
    });
    let locDetails = [];
    for (let i = 0; i < location.length; i++) {
        const loc0 = (0, flow_1.run)(`Details of place`, () => {
            return (0, tripPlan_1.tripPlan2)(tripDetails.request, location[i]);
        });
        locDetails.push(loc0);
    }
    const allTogether = await (0, flow_1.run)('allTogether', async () => {
        const results = await Promise.all(locDetails);
        const itineraries = { itineraries: [...results] };
        return itineraries;
    });
    return allTogether;
});
//# sourceMappingURL=itineraryGenerator.js.map