{
  config,
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
    {
      # HP USB-C G5 Essential Dock
      vendor = "03f0";
      product = "279d";
    }
  ];
in
{
  boot = {
    kernelPackages =
      if pkgs.system == "x86_64-linux" then
        lib.mkDefault pkgs.linuxPackages_cachyos-lto
      else
        lib.mkDefault pkgs.linuxPackages_latest;
    initrd.systemd.enable = true;
    blacklistedKernelModules =
      lib.optionals (lib.versionOlder "6.15" config.boot.kernelPackages.kernel.version)
        [
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

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

  services = {
    logind = {
      powerKey = "suspend";
      lidSwitch = "suspend";
      lidSwitchExternalPower = "suspend";
      lidSwitchDocked = "ignore";
    };
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          "10-disable-camera" = {
            "wireplumber.profiles" = {
              main."monitor.libcamera" = "disabled";
            };
          };
        };
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-increase-headroom.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  {
                    node.name = "~alsa_output.*"
                  }
                ]
                actions = {
                  update-props = {
                    api.alsa.headroom = 8192
                  }
                }
              }
            ]
          '')
        ];
      };
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 44100;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 512;
        };
      };
    };
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
}
