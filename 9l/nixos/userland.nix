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
      loupe
      mpv
      neovim
      papers
      pciutils
      resources
      usbutils
      wl-clipboard
    ];
    cosmic.excludePackages = with pkgs; [
      cosmic-player
      cosmic-store
    ];
  };

  services = {
    desktopManager.cosmic = {
      enable = true;
      xwayland.enable = true;
    };
    displayManager.cosmic-greeter = {
      enable = true;
    };
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
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    kdeconnect = {
      enable = true;
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
