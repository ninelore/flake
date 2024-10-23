{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_transparent";
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter = {
            command = "mylang-formatter";
          };
        }
      ];
    };
    extraPackages = with pkgs; [
      bash-language-server
      clang-tools
      cmake-language-server
      docker-compose-language-service
      dockerfile-language-server-nodejs
      gopls
      lua-language-server
      pkgs-small.nushell
      marksman
      nixd
      python312Packages.python-lsp-server
      rust-analyzer
      typescript-language-server
      vscode-langservers-extracted
      vue-language-server
      yaml-language-server
    ];
  };
}
