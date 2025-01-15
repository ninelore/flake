{
  inputs,
  lib,
  ...
}:
{
  home.stateVersion = "24.05";

  imports = [
    ./cliApps.nix
    ./git.nix
    ./nix-scripts.nix
    ./sh.nix
  ];

  nixpkgs.config = import ../nix/config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../nix/config.nix;

  nix.channels = {
    nixpkgs = lib.mkDefault inputs.nixpkgs;
  };

  programs = {
    home-manager.enable = true;
  };

  services = {
    gpg-agent.enable = true;
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
