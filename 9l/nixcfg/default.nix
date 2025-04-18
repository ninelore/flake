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
      trusted-users = [
        "root"
        "@wheel"
        "@sudo"
      ];
    };
  };
}
