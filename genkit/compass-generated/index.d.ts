import { ConnectorConfig, DataConnect, QueryRef, QueryPromise } from 'firebase/data-connect';
export const connectorConfig: ConnectorConfig;

export type TimestampString = string;

export type UUIDString = string;

export type Int64String = string;

export type DateString = string;


export interface Activity_Key {
  ref: string;
  destinationRef: string;
  __typename?: 'Activity_Key';
}

export interface GetActivitiesForPlaceResponse {
  activities: ({
    ref: string;
    destinationRef: string;
    name: string;
    description: string;
    locationName: string;
    timeOfDay: string;
    price: number;
    familyFriendly: boolean;
    duration: number;
    imageUrl: string;
  } & Activity_Key)[];
}

export interface GetActivitiesForPlaceVariables {
  placeId: string;
}

export interface GetNearestPlaceResponse {
  places_embedding_similarity: ({
    ref: string;
    name: string;
    country: string;
    continent: string;
    knownFor: string;
    tags: string[];
    imageUrl: string;
  } & Place_Key)[];
}

export interface GetNearestPlaceVariables {
  placeDescriptionVector: {
  };
}

export interface GetPlaceResponse {
  place?: {
    ref: string;
    continent: string;
    country: string;
    embedding: {
    };
      imageUrl: string;
      knownFor: string;
      name: string;
      tags: string[];
  } & Place_Key;
}

export interface GetPlaceVariables {
  placeId: Place_Key;
}

export interface ListActivitiesResponse {
  activities: ({
    ref: string;
    destinationRef: string;
    name: string;
    description: string;
    locationName: string;
    timeOfDay: string;
    price: number;
    familyFriendly: boolean;
    duration: number;
    imageUrl: string;
  } & Activity_Key)[];
}

export interface ListPlacesByContinentResponse {
  places: ({
    ref: string;
    name: string;
    country: string;
    continent: string;
    knownFor: string;
    tags: string[];
    imageUrl: string;
  } & Place_Key)[];
}

export interface ListPlacesByContinentVariables {
  continent: string;
}

export interface ListPlacesResponse {
  places: ({
    ref: string;
    name: string;
    country: string;
    continent: string;
    knownFor: string;
    tags: string[];
    imageUrl: string;
  } & Place_Key)[];
}

export interface Place_Key {
  ref: string;
  __typename?: 'Place_Key';
}



/* Allow users to create refs without passing in DataConnect */
export function getNearestPlaceRef(vars: GetNearestPlaceVariables): QueryRef<GetNearestPlaceResponse, GetNearestPlaceVariables>;
/* Allow users to pass in custom DataConnect instances */
export function getNearestPlaceRef(dc: DataConnect, vars: GetNearestPlaceVariables): QueryRef<GetNearestPlaceResponse,GetNearestPlaceVariables>;

export function getNearestPlace(vars: GetNearestPlaceVariables): QueryPromise<GetNearestPlaceResponse, GetNearestPlaceVariables>;
export function getNearestPlace(dc: DataConnect, vars: GetNearestPlaceVariables): QueryPromise<GetNearestPlaceResponse,GetNearestPlaceVariables>;


/* Allow users to create refs without passing in DataConnect */
export function getActivitiesForPlaceRef(vars: GetActivitiesForPlaceVariables): QueryRef<GetActivitiesForPlaceResponse, GetActivitiesForPlaceVariables>;
/* Allow users to pass in custom DataConnect instances */
export function getActivitiesForPlaceRef(dc: DataConnect, vars: GetActivitiesForPlaceVariables): QueryRef<GetActivitiesForPlaceResponse,GetActivitiesForPlaceVariables>;

export function getActivitiesForPlace(vars: GetActivitiesForPlaceVariables): QueryPromise<GetActivitiesForPlaceResponse, GetActivitiesForPlaceVariables>;
export function getActivitiesForPlace(dc: DataConnect, vars: GetActivitiesForPlaceVariables): QueryPromise<GetActivitiesForPlaceResponse,GetActivitiesForPlaceVariables>;


/* Allow users to create refs without passing in DataConnect */
export function getPlaceRef(vars: GetPlaceVariables): QueryRef<GetPlaceResponse, GetPlaceVariables>;
/* Allow users to pass in custom DataConnect instances */
export function getPlaceRef(dc: DataConnect, vars: GetPlaceVariables): QueryRef<GetPlaceResponse,GetPlaceVariables>;

export function getPlace(vars: GetPlaceVariables): QueryPromise<GetPlaceResponse, GetPlaceVariables>;
export function getPlace(dc: DataConnect, vars: GetPlaceVariables): QueryPromise<GetPlaceResponse,GetPlaceVariables>;


/* Allow users to create refs without passing in DataConnect */
export function listActivitiesRef(): QueryRef<ListActivitiesResponse, undefined>;/* Allow users to pass in custom DataConnect instances */
export function listActivitiesRef(dc: DataConnect): QueryRef<ListActivitiesResponse,undefined>;

export function listActivities(): QueryPromise<ListActivitiesResponse, undefined>;
export function listActivities(dc: DataConnect): QueryPromise<ListActivitiesResponse,undefined>;


/* Allow users to create refs without passing in DataConnect */
export function listPlacesRef(): QueryRef<ListPlacesResponse, undefined>;/* Allow users to pass in custom DataConnect instances */
export function listPlacesRef(dc: DataConnect): QueryRef<ListPlacesResponse,undefined>;

export function listPlaces(): QueryPromise<ListPlacesResponse, undefined>;
export function listPlaces(dc: DataConnect): QueryPromise<ListPlacesResponse,undefined>;


/* Allow users to create refs without passing in DataConnect */
export function listPlacesByContinentRef(vars: ListPlacesByContinentVariables): QueryRef<ListPlacesByContinentResponse, ListPlacesByContinentVariables>;
/* Allow users to pass in custom DataConnect instances */
export function listPlacesByContinentRef(dc: DataConnect, vars: ListPlacesByContinentVariables): QueryRef<ListPlacesByContinentResponse,ListPlacesByContinentVariables>;

export function listPlacesByContinent(vars: ListPlacesByContinentVariables): QueryPromise<ListPlacesByContinentResponse, ListPlacesByContinentVariables>;
export function listPlacesByContinent(dc: DataConnect, vars: ListPlacesByContinentVariables): QueryPromise<ListPlacesByContinentResponse,ListPlacesByContinentVariables>;


