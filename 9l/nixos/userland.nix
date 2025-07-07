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
      less
      lm_sensors
      mpv
      neovim
      pciutils
      resources
      usbutils
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
  };

  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    udev.packages =
      with pkgs;
      lib.optionals (system == "x86_64-linux") [
        via
      ];
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
    nix-index-database.comma.enable = true;
    nix-ld.enable = true;
    virt-manager.enable = true;
    wireshark.enable = true;
    ydotool.enable = true;
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "com.mitchellh.ghostty.desktop"
        "kitty.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      adwaita-fonts
      noto-fonts
      noto-fonts-cjk-sans
      open-sans
    ];
  };

  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
}
