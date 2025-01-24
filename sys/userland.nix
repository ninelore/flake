{
  pkgs,
  ...
}:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      dmidecode
      git
      # Fallback tools
      alacritty
      helix
      neovim
      textpieces
    ];
    gnome.excludePackages = (
      with pkgs;
      [
        atomix
        cheese
        epiphany
        evince
        geary
        gedit
        gnome-calendar
        gnome-contacts
        gnome-shell-extensions
        gnome-software
        gnome-system-monitor
        gnome-terminal
        gnome-text-editor
        gnome-tour
        gnome-user-docs
        gnome-weather
        hitori
        iagno
        simple-scan
        tali
        yelp
      ]
    );
  };

  services = {
    xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
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

  virtualisation = {
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
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
    waydroid.enable = true;
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

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "Alacritty.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      jetbrains-mono
      liberation_ttf
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      open-sans
    ];
  };
}
