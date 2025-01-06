{ pkgs, ... }:
{
  programs = {
    helix = {
      enable = true;
      defaultEditor = false;
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
      extraPackages = (import ../lib/lsp-dap.nix { pkgs = pkgs; });
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        fd
        gcc
        git
        gnumake
        ripgrep
        tree-sitter
        unzip
        wget
        wl-clipboard
        # Language Tools
        nixd
        nixfmt-rfc-style
      ];
    };
  };
}
