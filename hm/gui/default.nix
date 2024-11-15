{ pkgs, ... }:
{
  imports = [
    ./theme.nix
    ./gnome.nix
    ./zed.nix
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
        };
        font = {
          size = 11;
        };
        font.bold = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "Bold";
        };
        font.bold_italic = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "Bold Italic";
        };
        font.italic = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "Italic";
        };
        font.normal = {
          family = "JetBrainsMono Nerd Font Propo";
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
      gimp
      fractal
      helvum
      jetbrains.clion
      jetbrains.datagrip
      jetbrains.dataspell
      jetbrains.idea-ultimate
      obsidian
      onlyoffice-bin_latest
      papers
      protonvpn-gui
      scrcpy
      textpieces
      via
      webcord
      whatsapp-for-linux

      # gayming
      wineWowPackages.stagingFull
      bottles
      prismlauncher
    ];
  };
}
