{
  pkgs,
  ...
}:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      curl
      dmidecode
      docker-compose
      eyedropper
      firefox
      git
      gnome-maps
      helvum
      less
      lm_sensors
      mpv
      neovim
      papers
      pciutils
      ptyxis
      refine
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
        gnome-music
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
        totem
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
      # https://github.com/NixOS/nixpkgs/pull/395654
      # openocd
      # platformio-core
      via
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
        "org.gnome.Ptyxis.desktop"
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
