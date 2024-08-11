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
    ];
  };
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
}
