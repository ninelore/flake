{ pkgs, ... }:
{
  imports = [
    ../cli
    ./gnome.nix
    ./noiseSupression.nix
  ];

  home = {
    packages = with pkgs; [
      # GUI Apps
      appimage-run
      bottles
      gimp
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_GB-ise
      kicad-small
      libreoffice-fresh
      pdfarranger
      scrcpy
      spotify
      textpieces
      wineWowPackages.stagingFull
      wl-clipboard
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
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };
      settings = {
        shell = "nu";
        wayland_titlebar_color = "background";
        remember_window_size = true;
        enabled_layouts = "tall:bias=50;full_size=1;mirrored=false,fat:bias=50;full_size=1;mirrored=false,stack";
        confirm_os_window_close = 0;
      };
      keybindings = {
        "ctrl+shift+tab" = "layout_action mirror toggle";
      };
      themeFile = "Monokai_Soda";
    };
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
