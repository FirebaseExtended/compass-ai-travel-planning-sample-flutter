"use strict";
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
            if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
                t[p[i]] = s[p[i]];
        }
    return t;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.placeRetriever = exports.QueryOptions = void 0;
const backend_1 = require("@compass/backend");
const retriever_1 = require("@genkit-ai/ai/retriever");
const zod_1 = require("zod");
const firebase_1 = require("../config/firebase");
const googleai_1 = require("@genkit-ai/googleai");
const embedder_1 = require("@genkit-ai/ai/embedder");
exports.QueryOptions = zod_1.z.object({
    k: zod_1.z.number().optional(),
});
/**
 * placeRetriever is used to retrieve results from a storage system.
 * In our case, the storage system is Firebase Data Connect.
 * We are using the generated client SDKs for now, but once the admin
 * SDKs are available, we would likely prefer to use those.
 */
exports.placeRetriever = (0, retriever_1.defineRetriever)({
    name: 'postgres-placeRetriever',
    configSchema: exports.QueryOptions,
}, async (input, options) => {
    const requestEmbedding = await (0, embedder_1.embed)({
        embedder: googleai_1.textEmbeddingGecko001,
        content: input.text(),
    });
    const result = await (0, backend_1.getNearestPlace)(firebase_1.dataConnectInstance, { placeDescriptionVector: requestEmbedding });
    const resultData = result.data;
    return {
        documents: resultData.places_embedding_similarity.map((row) => {
            const { knownFor } = row, metadata = __rest(row, ["knownFor"]);
            return retriever_1.Document.fromText(knownFor, metadata);
        }),
    };
});
//# sourceMappingURL=placeRetriever.js.map