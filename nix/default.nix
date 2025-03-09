{ pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: { })
    ];
  };
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      #substituters = [ ];
      #trusted-public-keys = [ ];
      trusted-users = [
        "root"
        "@wheel"
        "@sudo"
      ];
    };
  };
}
