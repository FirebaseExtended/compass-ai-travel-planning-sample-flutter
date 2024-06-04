import { defineConfig } from 'vite';

export default defineConfig({
    server: {
      proxy: {
        '/textRefinement': {
          target: 'http://localhost:2222',
          changeOrigin: false,
          secure: false,
        },
        '/itineraryGenerator2': {
            target: 'http://localhost:2222',
            changeOrigin: false,
            secure: false,
          },
          '/': {
            target: 'http://localhost:6789',
            changeOrigin: false,
            secure: false,
        },
      },
    },
    // some other configuration
  })