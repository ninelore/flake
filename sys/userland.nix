{
  pkgs,
  ...
}:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      git
      vim
    ];
    gnome.excludePackages = (
      with pkgs;
      [
        atomix # puzzle game
        cheese # webcam tool
        epiphany # web browser
        evince # document viewer
        geary # Mail
        gedit # text editor
        gnome-calendar
        gnome-contacts
        gnome-music
        gnome-shell-extensions
        gnome-software
        gnome-terminal
        gnome-tour
        gnome-user-docs
        gnome-weather
        hitori # sudoku game
        iagno # go game
        simple-scan # scanner
        tali # poker game
        yelp
      ]
    );
  };

  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    udev.packages = with pkgs; [
      via
      platformio-core.udev
    ];
    logind.extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=ignore
    '';
    gnome.gnome-browser-connector.enable = true;
    flatpak.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
    };
  };

  programs = {
    adb.enable = true;
    command-not-found.enable = false;
    flashrom = {
      enable = true;
      # TODO: possibly need custon build
    };
    nix-index-database.comma.enable = true;
    nix-ld.enable = true;
    wireshark.enable = true;
    ydotool.enable = true;
    zsh.enable = true;
  };
}
