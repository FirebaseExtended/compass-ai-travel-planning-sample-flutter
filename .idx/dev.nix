{pkgs, ...}:
  {
    channel = "stable-24.05";
    packages = [
      pkgs.nodePackages.firebase-tools
      pkgs.jdk17
      pkgs.unzip
      (pkgs.postgresql_15.withPackages (p: [ p.pgvector ]))
      pkgs.nodejs_20
      pkgs.yarn
      pkgs.nodePackages.pnpm
      pkgs.bun
      pkgs.zip
      pkgs.curl
    ];
    env = {
      FIREBASE_DATACONNECT_POSTGRESQL_STRING = "postgresql://user:mypassword@localhost:5432/dataconnect?sslmode=disable";
      FIRESQL_PORT = "9939";
      # Sets environment variables in the workspace
      # You can get a Gemini API key through the IDX Integrations panel to the left!
      GOOGLE_API_KEY = "REPLACE_ME";
      MAPS_API_KEY = "";
    };
    processes = {
      postgresRun = {
        command = "postgres -D ./local -k /tmp";
      };
    };
    idx.extensions = [
      "Dart-Code.flutter"
      "mtxr.sqltools-driver-pg"
      "mtxr.sqltools"
      "GraphQL.vscode-graphql-syntax"
      "GoogleCloudTools.firebase-dataconnect-vscode"
    ];
    idx.workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        npm-install = ''
          cd proxy
          npm ci
        '';
      };
      onStart = {
        genkit-start = ''
          cd genkit
          npm install
          npm install --only=dev
          npx genkit-cli@1.0.4 start -- npx tsx --watch src/index.ts
        '';
        flutter-start = ''
          flutter upgrade
          flutter run --machine -d web-server --web-hostname 0.0.0.0 --web-port 6789 --dart-define=WEB_HOST=9000-$WEB_HOST
        '';
      };
    };
    idx.previews = {
      previews = {
        web = {
          command = [
            "npm"
            "run"
            "--prefix" 
            "proxy"
            "dev"
            "--"
            "--host"
            "0.0.0.0"
            "--port"
            "$PORT"
          ];
          manager = "flutter";
        };
      };
    };
  }
