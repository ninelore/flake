{
  inputs,
  pkgs,
  ...
}:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      home-manager
      inputs.nix-alien.packages.${pkgs.system}.nix-alien
    ];
    gnome.excludePackages = (
      with pkgs;
      [
        atomix # puzzle game
        cheese # webcam tool
        epiphany # web browser
        evince # document viewer
        gedit # text editor
        gnome-calendar
        gnome-contacts
        gnome-music
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
    flatpak.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=ignore
    '';
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
    };
  };

  programs = {
    zsh = {
      enable = true;
    };
    nix-ld.enable = true;
    wireshark.enable = true;
    adb.enable = true;
    ydotool.enable = true;
    flashrom = {
      enable = true;
      # package = ;
    };
  };
}
