{
  pkgs,
  ...
}:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      alacritty
      curl
      dmidecode
      docker-compose
      eyedropper
      firefox
      git
      gnome-tweaks
      gnome-maps
      less
      lm_sensors
      neovim
      papers
      pciutils
      ptyxis
      resources
      textpieces
      usbutils
    ];
    gnome.excludePackages = (
      with pkgs;
      [
        atomix
        cheese
        evince
        geary
        gedit
        gnome-calendar
        gnome-console
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
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };
    nix-index-database.comma.enable = true;
    nix-ld.enable = true;
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
      cantarell-fonts
      dejavu_fonts
      liberation_ttf
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      open-sans
    ];
  };
}
