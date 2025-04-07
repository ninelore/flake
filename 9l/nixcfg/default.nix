{ pkgs, ... }:
{
  nixpkgs = {
    overlays = [
      (final: prev: { })
    ];
  };
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [ "https://drakon64-nixos-cachyos-kernel.cachix.org" ];
      trusted-public-keys = [
        "drakon64-nixos-cachyos-kernel.cachix.org-1:J3gjZ9N6S05pyLA/P0M5y7jXpSxO/i0rshrieQJi5D0="
      ];
      trusted-users = [
        "root"
        "@wheel"
        "@sudo"
      ];
    };
  };
}
