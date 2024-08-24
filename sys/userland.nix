{
  inputs,
  systemConfig,
  pkgs,
  ...
}:
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
    ollama = {
      enable = true;
    };
  };

  systemd.packages = [
    (pkgs.writeTextFile {
      name = "monitors.conf";
      destination = "/etc/systemd/system/gdm.service.d/monitors.conf";
      text = ''
        [Service]
        ExecStartPre=cp -u /home/${systemConfig.username}/.config/monitors.xml /run/gdm/.config/
      '';
    })
  ];

  programs = {
    nix-ld.enable = true;
    wireshark.enable = true;    
    adb.enable = true;
    flashrom = {
      enable = true;
      # package = ;
    };
  };
}
