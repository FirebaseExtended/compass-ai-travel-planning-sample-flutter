import { initializeApp } from 'firebase/app';
import { getDataConnect, connectDataConnectEmulator } from 'firebase/data-connect'
import { connectorConfig } from '@compass/backend'

export default (host: string = 'localhost') => {
	const firebaseApp = initializeApp({projectId: 'demo-example'}); //TODO ENV VAR
	const dataConnect = getDataConnect(firebaseApp, connectorConfig)
    // It is always 'localhost' on the server
    connectDataConnectEmulator(
        dataConnect, 
        'localhost', 
        9399, 
        false
    );
	return dataConnect;
};