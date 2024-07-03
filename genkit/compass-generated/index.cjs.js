const { getDataConnect, queryRef, executeQuery } = require('firebase/data-connect');

const connectorConfig = {
  connector: 'my-connector',
  service: 'dataconnect',
  location: 'us-central1'
};
exports.connectorConfig = connectorConfig;

function getNearestPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(dcOrVars, vars, true);
  return queryRef(dcInstance, 'getNearestPlace', inputVars);
}
exports.getNearestPlaceRef = getNearestPlaceRef;
exports.getNearestPlace = function getNearestPlace(dcOrVars, vars) {
  return executeQuery(getNearestPlaceRef(dcOrVars, vars));
};

function getActivitiesForPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(dcOrVars, vars, true);
  return queryRef(dcInstance, 'getActivitiesForPlace', inputVars);
}
exports.getActivitiesForPlaceRef = getActivitiesForPlaceRef;
exports.getActivitiesForPlace = function getActivitiesForPlace(dcOrVars, vars) {
  return executeQuery(getActivitiesForPlaceRef(dcOrVars, vars));
};

function getPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(dcOrVars, vars, true);
  return queryRef(dcInstance, 'GetPlace', inputVars);
}
exports.getPlaceRef = getPlaceRef;
exports.getPlace = function getPlace(dcOrVars, vars) {
  return executeQuery(getPlaceRef(dcOrVars, vars));
};

function listActivitiesRef(dc) {
  const { dc: dcInstance} = validateArgs(dc, undefined);
  return queryRef(dcInstance, 'ListActivities');
}
exports.listActivitiesRef = listActivitiesRef;
exports.listActivities = function listActivities(dc) {
  return executeQuery(listActivitiesRef(dc));
};

function listPlacesRef(dc) {
  const { dc: dcInstance} = validateArgs(dc, undefined);
  return queryRef(dcInstance, 'ListPlaces');
}
exports.listPlacesRef = listPlacesRef;
exports.listPlaces = function listPlaces(dc) {
  return executeQuery(listPlacesRef(dc));
};

function validateArgs(dcOrVars, vars, validateVars) {
  let dcInstance;
  let realVars;
  // TODO; Check what happens if this is undefined.
  if(dcOrVars && 'dataConnectOptions' in dcOrVars) {
      dcInstance = dcOrVars;
      realVars = vars;
  } else {
      dcInstance = getDataConnect(connectorConfig);
      realVars = dcOrVars;
  }
  if(!dcInstance || (!realVars && validateVars)) {
      throw new Error('You didn\t pass in the vars!');
  }
  return { dc: dcInstance, vars: realVars };
}