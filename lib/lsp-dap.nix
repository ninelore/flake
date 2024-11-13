{ pkgs, ... }:
let
  list = with pkgs; [
    # LSP
    bash-language-server
    clang-tools
    cmake-language-server
    docker-compose-language-service
    dockerfile-language-server-nodejs
    gopls
    jdt-language-server
    lua-language-server
    nushell
    marksman
    nixd
    python312Packages.python-lsp-server
    rust-analyzer
    typescript-language-server
    vscode-langservers-extracted
    vue-language-server
    yaml-language-server

    # DAP
    lldb
    delve
    vscode-js-debug
  ];
in
list
