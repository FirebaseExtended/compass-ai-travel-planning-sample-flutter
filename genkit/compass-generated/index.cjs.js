const { getDataConnect, queryRef, executeQuery, validateArgs } = require('firebase/data-connect');

const connectorConfig = {
  connector: 'my-connector',
  service: 'dataconnect',
  location: 'us-central1'
};
exports.connectorConfig = connectorConfig;

function getNearestPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'getNearestPlace', inputVars);
}
exports.getNearestPlaceRef = getNearestPlaceRef;
exports.getNearestPlace = function getNearestPlace(dcOrVars, vars) {
  return executeQuery(getNearestPlaceRef(dcOrVars, vars));
};

function getActivitiesForPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'getActivitiesForPlace', inputVars);
}
exports.getActivitiesForPlaceRef = getActivitiesForPlaceRef;
exports.getActivitiesForPlace = function getActivitiesForPlace(dcOrVars, vars) {
  return executeQuery(getActivitiesForPlaceRef(dcOrVars, vars));
};

function getPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'GetPlace', inputVars);
}
exports.getPlaceRef = getPlaceRef;
exports.getPlace = function getPlace(dcOrVars, vars) {
  return executeQuery(getPlaceRef(dcOrVars, vars));
};

function listActivitiesRef(dc) {
  const { dc: dcInstance} = validateArgs(connectorConfig, dc, undefined);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'ListActivities');
}
exports.listActivitiesRef = listActivitiesRef;
exports.listActivities = function listActivities(dc) {
  return executeQuery(listActivitiesRef(dc));
};

function listPlacesRef(dc) {
  const { dc: dcInstance} = validateArgs(connectorConfig, dc, undefined);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'ListPlaces');
}
exports.listPlacesRef = listPlacesRef;
exports.listPlaces = function listPlaces(dc) {
  return executeQuery(listPlacesRef(dc));
};

function listPlacesByContinentRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'ListPlacesByContinent', inputVars);
}
exports.listPlacesByContinentRef = listPlacesByContinentRef;
exports.listPlacesByContinent = function listPlacesByContinent(dcOrVars, vars) {
  return executeQuery(listPlacesByContinentRef(dcOrVars, vars));
};

