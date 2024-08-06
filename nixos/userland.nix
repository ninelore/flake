{ inputs, pkgs, ... }:
{
  services = {
    xserver = {
      #enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
      gedit # text editor
      cheese # webcam tool
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      totem # video player
    ])
    ++ (with pkgs.gnome; [
      gnome-music
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  security = {
    polkit.enable = true;
  };
}
