import dataConnect from "./data-connect";

export const dataConnectInstance = dataConnect("localhost");
// Uncomment to work with your own production instance
// getDataConnect(app, {
//   location: 'us-central1',
//   connector: 'my-connector',
//   service: 'dataconnect',
// });