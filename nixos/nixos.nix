{ pkgs, inputs, ... }:
{
  system.stateVersion = "24.05";

  imports = [
    ../nix/nix.nix
    ./boot.nix
	  ./userland.nix
    ./audio.nix
    ./locale.nix
  ];

  documentation.nixos.enable = false;

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
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
  };

  services = {
    #printing.enable = true;
    udev.packages = [ pkgs.via ];
    flatpak.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=ignore
    '';
  };

  xdg.portal = {
    enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall = rec {
      allowedTCPPortRanges = [
        # Example
        #{
        #  from = 1714;
        #  to = 1764;
        #}
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    hosts = {
      "127.0.0.1" = [ "localhost" ];
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    openrazer = {
      enable = true;
      batteryNotifier.enable = false;
    };
    keyboard.qmk.enable = true;
  };

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
