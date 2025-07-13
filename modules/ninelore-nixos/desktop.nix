{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    ninelore.desktopOptions = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to use ninelore's basic NixOS configuration.";
      type = lib.types.bool;
    };

    ninelore.gaming = lib.mkEnableOption "gaming stuff";
    ninelore.vr = lib.mkEnableOption "vr stuff";
  };

  config =
    lib.mkIf config.ninelore.desktopOptions {
      assertions = [
        {
          assertion = config.ninelore.systemOptions;
          message = "ninelore.desktopOptions depends on ninelore.systemOptions";
        }
      ];
      environment = {
        localBinInPath = true;
        systemPackages = with pkgs; [
          cliphist
          firefox
          helvum
          mpv
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
      };

      virtualisation.waydroid.enable = true;

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
    // lib.mkIf config.ninelore.gaming {
      assertions = [
        {
          assertion = config.ninelore.desktopOptions;
          message = "ninelore.gaming depends on ninelore.desktopOptions";
        }
      ];
      environment.systemPackages = with pkgs; [
        wineWowPackages.stagingFull
        (pkgs.bottles.override { removeWarningPopup = true; })
        (pkgs.retroarch.withCores (
          cores:
          with cores;
          [
            melonds
            desmume
            vba-m
          ]
          ++ lib.optionals (pkgs.system == "x86_64-linux") [
            pcsx2
            ppsspp
          ]
        ))
      ];
      programs.steam = {
        enable = pkgs.system == "x86_64-linux";
        extraCompatPackages = [
          pkgs.proton-ge-custom
        ];
      };
    }
    // lib.mkIf config.ninelore.vr {
      assertions = [
        {
          assertion = config.ninelore.gaming;
          message = "ninelore.vr depends on ninelore.gaming";
        }
      ];
      services = {
        monado = {
          enable = true;
          defaultRuntime = true;
        };
        udev.packages = with pkgs; [ xr-hardware ];
      };
      systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "0";
        XRT_COMPOSITOR_COMPUTE = "1";
        # XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT = "1";
        AMD_VULKAN_ICD = "RADV";
      };
    };
}
