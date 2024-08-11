{ inputs, pkgs, ... }:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      curl
      home-manager
      neovim
      nix-index
      less
      usbutils
      inputs.nix-alien.packages.${pkgs.system}.nix-alien
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

  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    udev.packages = [ pkgs.via ];
    flatpak.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=ignore
    '';
  };

  programs = {
    nix-ld.enable = true;
    wireshark.enable = true;
    # I hate to have this outside of home-manager...
    steam = {
      enable = true;
      gamescopeSession.enable = true; # TODO: trial
    };
    adb.enable = true;
    flashrom = {
      enable = true;
      # package = ;
    };
  };
}
