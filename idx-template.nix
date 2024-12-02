{ pkgs, ... }: {
  packages = [
    pkgs.curl
    pkgs.unzip
  ];
  bootstrap = ''
    mkdir "$out"
    cp -rf ${./.}/* "$out"
    mkdir "$out/.idx"
    mkdir "$out/.vscode"
    mkdir "$out/.firebase"
    cp -rf ${./.}/.idx "$out"
    cp -rf ${./.}/.vscode "$out"
    cp -rf ${./.}/.firebase "$out"
    cp -rf ${./.}/.firebaserc "$out"
    cp -rf ${./.}/.gitignore "$out"
    cp -rf ${./.}/.gitattributes "$out"
    rm "$out/idx-template.nix"
    rm "$out/idx-template.json"
    curl -o local.zip 'https://firebasestorage.googleapis.com/v0/b/yt-rag.appspot.com/o/genkit%2Flocal.zip?alt=media&token=2f1d181d-9eda-4dc1-9ffc-e988f69c26f2'
    unzip local.zip -d "$out"
    chmod -R u+w "$out"
    rm "$out/local/postmaster.pid"
  '';
}
