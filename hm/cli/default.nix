{
  ...
}:
{
  home.stateVersion = "24.05";

  imports = [
    ./apps.nix
    ./nix-scripts.nix
    ./sh.nix
  ];

  programs = {
    home-manager.enable = true;
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
