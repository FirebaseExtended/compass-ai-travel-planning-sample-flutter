/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { getDataConnect, queryRef, executeQuery } from 'firebase/data-connect';

export const connectorConfig = {
  connector: 'my-connector',
  service: 'dataconnect',
  location: 'us-central1'
};

export function getNearestPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(dcOrVars, vars, true);
  return queryRef(dcInstance, 'getNearestPlace', inputVars);
}
export function getNearestPlace(dcOrVars, vars) {
  return executeQuery(getNearestPlaceRef(dcOrVars, vars));
}
export function getActivitiesForPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(dcOrVars, vars, true);
  return queryRef(dcInstance, 'getActivitiesForPlace', inputVars);
}
export function getActivitiesForPlace(dcOrVars, vars) {
  return executeQuery(getActivitiesForPlaceRef(dcOrVars, vars));
}
export function getPlaceRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(dcOrVars, vars, true);
  return queryRef(dcInstance, 'GetPlace', inputVars);
}
export function getPlace(dcOrVars, vars) {
  return executeQuery(getPlaceRef(dcOrVars, vars));
}
export function listActivitiesRef(dc) {
  const { dc: dcInstance} = validateArgs(dc, undefined);
  return queryRef(dcInstance, 'ListActivities');
}
export function listActivities(dc) {
  return executeQuery(listActivitiesRef(dc));
}
export function listPlacesRef(dc) {
  const { dc: dcInstance} = validateArgs(dc, undefined);
  return queryRef(dcInstance, 'ListPlaces');
}
export function listPlaces(dc) {
  return executeQuery(listPlacesRef(dc));
}
export function listPlacesByContinentRef(dcOrVars, vars) {
  const { dc: dcInstance, vars: inputVars} = validateArgs(dcOrVars, vars, true);
  return queryRef(dcInstance, 'ListPlacesByContinent', inputVars);
}
export function listPlacesByContinent(dcOrVars, vars) {
  return executeQuery(listPlacesByContinentRef(dcOrVars, vars));
}
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