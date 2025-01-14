{ pkgs, ... }:
{
  imports = [
    ./theme.nix
    ./gnome.nix
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        general.import = [
          "${pkgs.alacritty-theme}/monokai_charcoal.toml"
        ];
        window = {
          opacity = 0.8;
          startup_mode = "Maximized";
        };
        font = {
          size = 13;
          offset.y = 2;
        };
        font.bold = {
          family = "FantasqueSansM Nerd Font";
          style = "Bold";
        };
        font.bold_italic = {
          family = "FantasqueSansM Nerd Font";
          style = "Bold Italic";
        };
        font.italic = {
          family = "FantasqueSansM Nerd Font";
          style = "Italic";
        };
        font.normal = {
          family = "FantasqueSansM Nerd Font";
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
      nativeMessagingHosts = with pkgs; [
        gnome-browser-connector
      ];
    };
    obs-studio = {
      enable = true;
    };
  };

  home = {
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = 1;
      NIXOS_OZONE_WL = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_ENABLE_HIGHDPI_SCALING = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
    };
    packages = with pkgs; [
      # GUI Apps
      android-studio
      appimage-run
      discord-canary
      fractal
      gaphor
      gimp
      helvum
      jetbrains.clion
      jetbrains.datagrip
      jetbrains.dataspell
      jetbrains.idea-ultimate
      libreoffice-fresh
      obsidian
      protonvpn-gui
      scrcpy
      textpieces
      via
      wl-clipboard

      # gayming
      wineWowPackages.stagingFull
      bottles
      prismlauncher
      (pkgs.retroarch.withCores (
        cores: with cores; [
          melonds
          desmume
          pcsx2
          ppsspp
          vba-m
        ]
      ))
    ];
  };
}
