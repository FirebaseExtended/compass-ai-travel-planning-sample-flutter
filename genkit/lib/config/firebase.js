"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dataConnectInstance = exports.firebaseConfig = void 0;
const app_1 = require("firebase/app");
const data_connect_1 = require("firebase/data-connect");
exports.firebaseConfig = {
    apiKey: 'AIzaSyCJIrZkGH04TIXcP2t8hvo97yKwGmwD-1k',
    authDomain: 'yt-rag.firebaseapp.com',
    projectId: 'yt-rag',
    storageBucket: 'yt-rag.appspot.com',
    messagingSenderId: '27624284998',
    appId: '1:27624284998:web:5ca7f72008a73b94c4bb47',
};
const app = (0, app_1.initializeApp)(exports.firebaseConfig);
exports.dataConnectInstance = (0, data_connect_1.getDataConnect)(app, {
    location: 'us-central1',
    connector: 'my-connector',
    service: 'dataconnect',
});
//# sourceMappingURL=firebase.js.map