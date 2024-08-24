{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      # nixos-unstable-small
      (final: _prev: {
        pkgs-small = import inputs.nixpkgs-small {
          system = final.system;
          config.allowUnfree = true;
        };
      })
      # Custom packages
      (final: _prev: import ../pkgs { pkgs = _prev.pkgs; })
      # Wezterm
      #(final: _prev: { wezterm = inputs.wezterm.packages."${final.system}".default; })
      # VSCode Extensions
      inputs.vscode-ext.overlays.default
    ];
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [ "https://devenv.cachix.org" ];
      trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
