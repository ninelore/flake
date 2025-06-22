{ inputs, pkgs, ... }:
{
  nixpkgs = {
    overlays = [
      (final: prev: {
        waydroid = prev.waydroid.override {
          python3Packages = pkgs.python312Packages;
        };
        devtoolbox = prev.devtoolbox.override {
          python3Packages = pkgs.python312Packages;
        };
      })
    ];
  };
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
        "@sudo"
      ];
    };
    registry = {
      ninelore.flake = inputs.self;
    };
  };
}
