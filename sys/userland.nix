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
        gnome-shell-extensions
        gnome-software
        gnome-system-monitor
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
    ollama.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=ignore
    '';
    gnome.gnome-browser-connector.enable = true;
    flatpak.enable = false;
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
      };
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            pkgs.OVMFFull.fd
          ];
        };
      };
    };
  };

  programs = {
    adb.enable = true;
    command-not-found.enable = false;
    flashrom = {
      enable = true;
      package = pkgs.flashprog;
    };
    gamemode = {
      enable = true;
    };
    nix-index-database.comma.enable = true;
    nix-ld.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true; # TODO: trial
    };
    virt-manager.enable = true;
    wireshark.enable = true;
    ydotool.enable = true;
    zsh.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      font-awesome
      jetbrains-mono
      material-icons
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
