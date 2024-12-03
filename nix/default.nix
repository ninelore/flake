{ pkgs, ... }:
{
  nixpkgs = {
    config = import ./config.nix;
    overlays = [
      #(final: prev: { })
      # Custom packages
      (final: prev: import ../pkgs { pkgs = prev.pkgs; })
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
      ];
    };
  };
}
