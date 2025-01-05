{ pkgs, ... }:
{
  xdg.configFile."nvim".source = ../nvim;
  programs.neovim = {
    enable = true;
    extraPackages = (import ../lib/lsp-dap.nix { pkgs = pkgs; });
  };
}
