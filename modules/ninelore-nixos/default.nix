{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  usbDontAutosuspend = [
    {
      # HP USB-C G5 Essential Dock
      vendor = "03f0";
      product = "279d";
    }
  ];
in
{
  options = {
    ninelore.systemOptions = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to use ninelore's basic NixOS configuration.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.ninelore.systemOptions {
    system.stateVersion = lib.mkDefault "24.05";

    imports = [
      inputs.chaotic.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
      ./desktop.nix
    ];

    nix = {
      package = pkgs.nixVersions.latest;
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
    };

    nixpkgs.overlays = [
      (final: prev: { })
    ];

    boot = {
      kernelPackages =
        if pkgs.system == "x86_64-linux" then
          lib.mkDefault pkgs.linuxPackages_cachyos-lto
        else
          lib.mkDefault pkgs.linuxPackages_latest;
      initrd.systemd.enable = true;
      blacklistedKernelModules = [
        "r8153_ecm"
        "r8152"
      ];
      kernelParams = [
        "boot.shell_on_fail"
      ];
      tmp.cleanOnBoot = true;
      loader = {
        timeout = 0;
        systemd-boot = {
          enable = true;
          configurationLimit = 15;
        };
        efi.canTouchEfiVariables = true;
      };
      binfmt.emulatedSystems =
        lib.optionals (pkgs.system == "x86_64-linux") [ "aarch64-linux" ]
        ++ lib.optionals (pkgs.system == "aarch64-linux") [ "x86_64-linux" ];
    };

    systemd.services."getty@tty11" = {
      enable = true;
      wantedBy = [ "getty.target" ];
      serviceConfig.Restart = "always";
    };

    hardware =
      {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
        i2c.enable = true;
        keyboard.qmk.enable = true;
      }
      // lib.optionalAttrs (pkgs.system != "x86_64-linux") {
        graphics.enable32Bit = lib.mkForce false;
      };

    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            keepEnv = true;
            persist = true;
          }
        ];
      };
      rtkit.enable = true;
      pam.services.systemd-run0 = { };
    };

    networking = {
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;
      firewall = rec {
        enable = true;
        allowPing = false;
        allowedTCPPortRanges = [
          # KDEConnect
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
      hosts = {
        "127.0.0.1" = [
          "localhost"
          "lolcathost"
        ];
      };
    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8" # For ISO 8601 date format
    ];
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "en_DK.UTF-8"; # For ISO 8601 date format
    };

    environment.systemPackages = with pkgs; [
      curl
      dmidecode
      docker-compose
      git
      less
      lm_sensors
      neovim
      pciutils
      scripts-9l
      usbutils
    ];

    programs = {
      gnupg.agent = {
        enable = true;
      };
      nix-index-database.comma.enable = true;
      nix-ld.enable = true;
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
    };

    services = {
      udev.extraRules = lib.concatLines (
        [ ]
        ++ (builtins.map (
          dev:
          ''ACTION=="bind", SUBSYSTEM=="usb", ATTR{idVendor}=="${dev.vendor}", ATTR{idProduct}=="${dev.product}", TEST=="power/control", ATTR{power/control}="on"''
        ) usbDontAutosuspend)
      );
    };

    powerManagement = {
      enable = true;
      powertop = {
        enable = true;
        postStart = lib.concatLines (
          builtins.map (
            dev:
            ''${lib.getExe' config.systemd.package "udevadm"} trigger -c bind -s usb -a idVendor=${dev.vendor} -a idProduct=${dev.product}''
          ) usbDontAutosuspend
        );
      };
    };
  };
}
