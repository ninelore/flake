{ pkgs, ... }:
{
  imports = [
    ../cli
    ./theme.nix
    ./gnome.nix
    ./noiseSupression.nix
  ];

  home = {
    packages = with pkgs; [
      # GUI Apps
      appimage-run
      bottles
      discord-canary
      fractal
      gimp
      helvum
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_GB-ise
      kicad-small
      libreoffice-fresh
      pdfarranger
      scrcpy
      spotify
      textpieces
      tuba
      wineWowPackages.stagingFull
      wl-clipboard
      zed-editor_git
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
    alacritty = {
      enable = true;
      settings = {
        general.import = [
          "${pkgs.alacritty-theme}/monokai_charcoal.toml"
        ];
        colors.primary = {
          background = "#191515";
        };
        window = {
          opacity = 0.8;
          startup_mode = "Maximized";
        };
        font = {
          size = 11;
        };
        font.bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        font.bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        font.italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        font.normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };
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
