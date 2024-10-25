{ pkgs, ... }:
{
  imports = [
    ./theme.nix
    ./gnome.nix
    ./vscode.nix
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        import = [
          "${pkgs.alacritty-theme}/dracula_plus.toml"
        ];
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

  services = {
    kdeconnect.enable = true;
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
      blender
      gimp
      fractal
      helvum
      jetbrains.clion
      jetbrains.datagrip
      jetbrains.dataspell
      jetbrains.goland
      jetbrains.idea-ultimate
      obsidian
      textpieces
      onlyoffice-bin_latest
      papers
      protonvpn-gui
      scrcpy
      via
      webcord

      # gayming
      wineWowPackages.stagingFull
      bottles
      prismlauncher
    ];
  };
}
