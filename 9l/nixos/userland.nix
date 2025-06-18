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
      firefox
      git
      helvum
      kitty
      less
      lm_sensors
      mpv
      neovim
      pciutils
      resources
      usbutils
    ];
    cosmic.excludePackages = with pkgs; [
      cosmic-player
      cosmic-store
    ];
    gnome.excludePackages = with pkgs; [
      baobab
      cheese
      decibels
      epiphany
      evince
      geary
      gnome-calendar
      gnome-contacts
      gnome-logs
      gnome-music
      gnome-shell-extensions
      gnome-software
      gnome-system-monitor
      gnome-terminal
      gnome-text-editor
      gnome-tour
      gnome-user-docs
      gnome-weather
      simple-scan
      totem
      yelp
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      khelpcenter
    ];
  };

  services = {
    desktopManager = {
      cosmic = {
        enable = true;
        xwayland.enable = true;
      };
      gnome.enable = true;
      # plasma6.enable = true;
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      # sddm = {
      #   enable = true;
      #   wayland.enable = true;
      # };
    };
    udev.packages =
      with pkgs;
      lib.optionals (system == "x86_64-linux") [
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
    dconf.enable = true;
    flashprog.enable = true;
    flashrom.enable = true;
    gamemode = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
    };
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
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
        "kitty.desktop"
      ];
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      adwaita-fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      noto-fonts
      noto-fonts-cjk-sans
      open-sans
    ];
  };

  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
}
