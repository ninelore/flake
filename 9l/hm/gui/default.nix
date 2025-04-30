{ lib, pkgs, ... }:
{
  imports = [
    ../cli
    #./plasma
    ./gnome.nix
    ./noiseSupression.nix
  ];

  home = {
    packages =
      with pkgs;
      [
        # GUI Apps
        appimage-run
        bottles
        devtoolbox
        gimp3
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_GB-ise
        kicad-small
        libreoffice-fresh
        pdfarranger
        scrcpy
        sly
        warp
        wl-clipboard
      ]
      ++ lib.optionals (pkgs.system == "x86_64-linux") [
        spotify
        wineWowPackages.stagingFull
      ];
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = 1;
      NIXOS_OZONE_WL = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_ENABLE_HIGHDPI_SCALING = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    };
    firefox = {
      enable = true;
    };
    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        mpris
        sponsorblock
        thumbfast
        uosc
        videoclip
      ];
      scriptOpts = {
        thumbfast = {
          spawn_first = true;
          network = true;
          hwdec = true;
        };
      };
    };
  };
}
