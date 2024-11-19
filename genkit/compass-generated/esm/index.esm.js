import { getDataConnect, queryRef, executeQuery, validateArgs } from 'firebase/data-connect';

export const connectorConfig = {
  connector: 'my-connector',
  service: 'dataconnect',
  location: 'us-central1'
};

export function getNearestPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'getNearestPlace', inputVars);
}
export function getNearestPlace(dcOrVars, vars) {
  return executeQuery(getNearestPlaceRef(dcOrVars, vars));
}
export function getActivitiesForPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'getActivitiesForPlace', inputVars);
}
export function getActivitiesForPlace(dcOrVars, vars) {
  return executeQuery(getActivitiesForPlaceRef(dcOrVars, vars));
}
export function getPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'GetPlace', inputVars);
}
export function getPlace(dcOrVars, vars) {
  return executeQuery(getPlaceRef(dcOrVars, vars));
}
export function listActivitiesRef(dc) {
  const { dc: dcInstance} = validateArgs(connectorConfig, dc, undefined);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'ListActivities');
}
export function listActivities(dc) {
  return executeQuery(listActivitiesRef(dc));
}
export function listPlacesRef(dc) {
  const { dc: dcInstance} = validateArgs(connectorConfig, dc, undefined);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'ListPlaces');
}
export function listPlaces(dc) {
  return executeQuery(listPlacesRef(dc));
}
export function listPlacesByContinentRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  if('_useGeneratedSdk' in dcInstance) {
    dcInstance._useGeneratedSdk();
  } else {
    console.error('Please update to the latest version of the Data Connect SDK by running `npm install firebase@dataconnect-preview`.');
  }
  return queryRef(dcInstance, 'ListPlacesByContinent', inputVars);
}
export function listPlacesByContinent(dcOrVars, vars) {
  return executeQuery(listPlacesByContinentRef(dcOrVars, vars));
}
