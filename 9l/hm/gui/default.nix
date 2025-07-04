{ lib, pkgs, ... }:
{
  imports = [
    ../cli
    ./gnome.nix
    ./noiseSupression.nix
  ];

  xdg.dataFile."color-schemes/MonokaiPro.colors".source = ./MonokaiPro.colors;

  home = {
    packages =
      with pkgs;
      [
        # GUI Apps
        appimage-run
        (pkgs.bottles.override { removeWarningPopup = true; })
        darktable
        #devtoolbox # https://github.com/NixOS/nixpkgs/issues/418879
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
        # Fonts
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
      ]
      ++ lib.optionals (pkgs.system == "x86_64-linux") [
        spotify
        wineWowPackages.stagingFull
      ];
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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
        (quality-menu.override { oscSupport = true; })
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

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Adwaita Sans 11" ];
      serif = [ "Adwaita Sans 11" ];
      monospace = [ "JetBrainsMono Nerd Font 11" ];
    };
  };
}
