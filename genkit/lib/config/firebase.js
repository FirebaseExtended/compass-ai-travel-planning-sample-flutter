"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.dataConnectInstance = void 0;
const data_connect_1 = __importDefault(require("./data-connect"));
exports.dataConnectInstance = (0, data_connect_1.default)("localhost");
// Uncomment to work with your own production instance
// getDataConnect(app, {
//   location: 'us-central1',
//   connector: 'my-connector',
//   service: 'dataconnect',
// });
//# sourceMappingURL=firebase.js.map