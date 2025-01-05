{ pkgs, ... }:
{
  programs = {
    helix = {
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
      extraPackages = (import ../lib/lsp-dap.nix { pkgs = pkgs; });
    };
    neovim = {
      enable = true;
      extraPackages = (import ../lib/lsp-dap.nix { pkgs = pkgs; });
    };
  };
}
