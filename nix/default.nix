{ inputs, pkgs, ... }:
{
  nixpkgs = {
    config = import ./config.nix;
    overlays = [
      (final: prev: {
        # nixos-unstable-small
        pkgs-small = import inputs.nixpkgs-small {
          system = final.system;
          config.allowUnfree = true;
        };
        # Aarch64 fd
        aarch64fd = inputs.nixpkgs.legacyPackages."aarch64-linux".OVMF.fd;
        # Maintain more recent gnome extensions
        gnomeExtensions = inputs.nixpkgs-9l-gnomeExt.legacyPackages.${final.system}.gnomeExtensions;
      })
      # Custom packages
      (final: prev: import ../pkgs { pkgs = prev.pkgs; })
    ];
  };
  nix = {
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
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
