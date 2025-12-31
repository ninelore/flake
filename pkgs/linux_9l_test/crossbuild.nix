let
  pkgs = import <nixpkgs> {
    localSystem = "x86_64-linux"; # buildPlatform
    crossSystem = "aarch64-linux"; # hostPlatform
  };
in
pkgs.callPackage ./default.nix { }
