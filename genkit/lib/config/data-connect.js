"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const app_1 = require("firebase/app");
const data_connect_1 = require("firebase/data-connect");
const backend_1 = require("@compass/backend");
exports.default = (host = 'localhost') => {
    const firebaseApp = (0, app_1.initializeApp)({});
    const dataConnect = (0, data_connect_1.getDataConnect)(firebaseApp, backend_1.connectorConfig);
    // It is always 'localhost' on the server
    (0, data_connect_1.connectDataConnectEmulator)(dataConnect, 'localhost', 9399, false);
    return dataConnect;
};
//# sourceMappingURL=data-connect.js.map