{ pkgs, ... }:
{
  boot = {
    consoleLogLevel = 2;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    plymouth = {
      enable = true;
      theme = "bgrt-luks";
      themePackages = [ pkgs.plymouth-bgrt-luks ];
    };
    kernelParams = [
      "boot.shell_on_fail"
      # eye candy below
      "quiet"
      "splash"
      "rd.systemd.show_status=error"
      "rd.udev.log_level=2"
      "udev.log_priority=2"
    ];

    tmp.cleanOnBoot = true;
    #supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
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

  hardware.pulseaudio.enable = false;
  security = {
    rtkit.enable = true;
    doas.enable = true;
  };
  services.pipewire = {
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

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
