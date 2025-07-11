{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      cliphist
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
      usbutils
      wl-clipboard
    ];
    cosmic.excludePackages = with pkgs; [
      cosmic-player
      cosmic-store
    ];
    variables = {
      COSMIC_DATA_CONTROL_ENABLED = 1;
    };
  };

  services = {
    desktopManager.cosmic = {
      enable = true;
      xwayland.enable = true;
    };
    displayManager.cosmic-greeter.enable = true;
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
    steam = {
      enable = pkgs.system == "x86_64-linux";
      extraCompatPackages = [
        inputs.chaotic.legacyPackages.${pkgs.system}.proton-ge-custom
      ];
    };
    virt-manager.enable = true;
    wireshark.enable = true;
    ydotool.enable = true;
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
        "com.system76.CosmicTerm.desktop"
      ];
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      adwaita-fonts
      inter
      noto-fonts
      noto-fonts-cjk-sans
      open-sans
    ];
  };

  systemd.user.services.cliphist = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    description = "Cliphist";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store'';
    };
  };

  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
}
