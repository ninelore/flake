{ inputs, pkgs, ... }:
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
      substituters = [ "https://devenv.cachix.org" ];
      trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
