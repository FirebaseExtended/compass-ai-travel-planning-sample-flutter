"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.retrievers = exports.flows = exports.tools = void 0;
const core_1 = require("@genkit-ai/core");
const flow_1 = require("@genkit-ai/flow");
const firebase_1 = require("@genkit-ai/firebase");
const googleai_1 = require("@genkit-ai/googleai");
const dotprompt_1 = require("@genkit-ai/dotprompt");
// importing our own tooling.
const tools = __importStar(require("./tools"));
exports.tools = tools;
const flows = __importStar(require("./flows"));
exports.flows = flows;
const retrievers = __importStar(require("./retrievers"));
exports.retrievers = retrievers;
const firebase_2 = require("./config/firebase");
const google_cloud_1 = __importDefault(require("@genkit-ai/google-cloud"));
const sdk_trace_base_1 = require("@opentelemetry/sdk-trace-base");
(0, core_1.configureGenkit)({
    plugins: [
        (0, firebase_1.firebase)({
            flowStateStore: { collection: 'flowTraceStore' },
        }),
        (0, googleai_1.googleAI)(),
        // Uncomment to use Vertex AI instead.
        // vertexAI({
        //   location: 'us-central1',
        // }),
        (0, dotprompt_1.dotprompt)({ dir: 'prompts' }),
        (0, googleai_1.googleAI)({ apiKey: firebase_2.firebaseConfig.apiKey }),
        (0, google_cloud_1.default)({
            forceDevExport: true, // Set this to true to export telemetry for local runs
            telemetryConfig: {
                sampler: new sdk_trace_base_1.AlwaysOnSampler(),
                autoInstrumentation: true,
                autoInstrumentationConfig: {
                    '@opentelemetry/instrumentation-fs': { enabled: false },
                    '@opentelemetry/instrumentation-dns': { enabled: false },
                    '@opentelemetry/instrumentation-net': { enabled: false },
                },
                metricExportIntervalMillis: 5000,
                metricExportTimeoutMillis: 5000,
            },
        }),
    ],
    flowStateStore: 'firebase',
    traceStore: 'firebase',
    enableTracingAndMetrics: true,
    logLevel: 'debug',
    telemetry: {
        instrumentation: 'googleCloud',
        logger: 'googleCloud',
    },
});
(0, flow_1.startFlowsServer)();
//# sourceMappingURL=index.js.map