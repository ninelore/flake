{ pkgs, ... }:
{
  boot = {
    consoleLogLevel = 0;
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
    kernelParams = [
      "boot.shell_on_fail"
      # eye candy below
      "quiet"
      "splash"
      "rd.systemd.show_status=error"
      "rd.udev.log_level=0"
      "udev.log_priority=0"
    ];
    plymouth = {
      enable = true;
      theme = "bgrt-luks";
      themePackages = [ pkgs.plymouth-bgrt-luks ];
    };
    tmp.cleanOnBoot = true;
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        configurationLimit = 15;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    openrazer = {
      enable = true;
      batteryNotifier.enable = false;
    };
    keyboard.qmk.enable = true;
  };

  security = {
    rtkit.enable = true;
    pam.services.systemd-run0 = { };
  };
  services = {
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
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
