{pkgs, ...}:
  let firebase-ext = pkgs.fetchurl {
    url =
      "https://firebasestorage.googleapis.com/v0/b/firemat-preview-drop/o/vsix%2Ffirebase-vscode-0.2.8.vsix?alt=media&token=ba272e6e-c6b3-4860-bc2a-cd5b9cd7e022";
    hash = "sha256-n4D70K61vThL3Tdjq1lq2Z/+4CBLtRj7ePY8uiv0taw=";
    name = "firebase.vsix";
  };
  in {
  channel = "stable-23.11";
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
    POSTGRESQL_CONN_STRING = "postgresql://user:mypassword@localhost:5432/dataconnect?sslmode=disable";
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
    "${firebase-ext}"
  ];
  idx.workspace = {
    # Runs when a workspace is first created with this `dev.nix` file
    onCreate = {
      git-lfs-fetch = ''
        curl -o local.zip 'https://firebasestorage.googleapis.com/v0/b/yt-rag.appspot.com/o/genkit%2Flocal.zip?alt=media&token=2f1d181d-9eda-4dc1-9ffc-e988f69c26f2'
        unzip local.zip -d .
      '';
      npm-install = ''
        cd proxy
        npm ci
      '';
    };
    onStart = {
      genkit-start = ''
        cd genkit
        npm ci
        npx genkit start 
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
