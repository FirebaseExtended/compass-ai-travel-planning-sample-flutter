import { initializeApp } from "firebase/app";
import { getDataConnect } from "firebase/data-connect";

export const firebaseConfig = {
    apiKey: 'AIzaSyCJIrZkGH04TIXcP2t8hvo97yKwGmwD-1k',
    authDomain: 'yt-rag.firebaseapp.com',
    projectId: 'yt-rag',
    storageBucket: 'yt-rag.appspot.com',
    messagingSenderId: '27624284998',
    appId: '1:27624284998:web:5ca7f72008a73b94c4bb47',
  };

const app = initializeApp(firebaseConfig);

export const dataConnectInstance = getDataConnect(app, {
  location: 'us-central1',
  connector: 'my-connector',
  service: 'dataconnect',
});