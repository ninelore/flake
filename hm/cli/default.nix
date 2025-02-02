{
  inputs,
  lib,
  ...
}:
{
  home.stateVersion = "24.05";

  imports = [
    ./apps.nix
    ./nix-scripts.nix
    ./sh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.channels = {
    nixpkgs = lib.mkDefault inputs.nixpkgs;
  };

  programs = {
    home-manager.enable = true;
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
