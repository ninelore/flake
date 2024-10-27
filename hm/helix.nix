{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter = {
            command = "nixfmt";
          };
        }
      ];
      language-server.nixd = {
        command = "nixd";
      };
    };
    extraPackages = with pkgs; [
      bash-language-server
      clang-tools
      cmake-language-server
      docker-compose-language-service
      dockerfile-language-server-nodejs
      gopls
      jdt-language-server
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
