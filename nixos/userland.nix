{ pkgs, ... }:
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
        epiphany # web browser
        evince # document viewer
        gedit # text editor 
        gnome-calendar     
        gnome-terminal
        gnome-tour
        gnome-user-docs
        simple-scan # scanner
        yelp
      ])
      ++ (with pkgs.gnome; [
        atomix # puzzle game
        gnome-contacts
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
