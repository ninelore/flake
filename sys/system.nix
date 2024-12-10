{ pkgs, ... }:
{
  boot = {
    consoleLogLevel = 15;
    initrd = {
      systemd.enable = true;
    };
    kernelParams = [
      "boot.shell_on_fail"
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
    pam.services.systemd-run0 = { };
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
