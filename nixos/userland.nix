{ inputs, pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      gnome-tweaks
    ];
    gnome.excludePackages =
      (with pkgs; [
        cheese # webcam tool
        evince # document viewer
        geary # email reader
        gedit # text editor      epiphany # web browser
        gnome-terminal
        gnome-tour
        gnome-user-docs
        simple-scan # scanner
        snapshot
        totem # video player
      ])
      ++ (with pkgs.gnome; [
        atomix # puzzle game
        gnome-contacts
        gnome-maps
        gnome-music
        gnome-weather
        hitori # sudoku game
        iagno # go game
        tali # poker game
      ]);
  };

  security = {
    polkit.enable = true;
  };
}
