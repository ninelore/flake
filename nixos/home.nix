{ config, ... }: {
  imports = [
    ../home-manager/configcopy.nix
    ../home-manager/git.nix
    ../home-manager/hyprland.nix
    ../home-manager/mako.nix
    ../home-manager/packages.nix
    ../home-manager/sh.nix
    ../home-manager/theme.nix
  ];

  news.display = "show";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  home = {
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";

      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      GDK_BACKEND = "wayland,x11";
      GDK_SCALE = 1.25;
      GDK_DPI_SCALE = 1;
      MOZ_ENABLE_WAYLAND = 1;
      NIXOS_OZONE_WL = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_ENABLE_HIGHDPI_SCALING = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  gtk.gtk3.bookmarks =
    let
      home = config.home.homeDirectory;
    in
    [
      "file://${home} Home"
    ];

  programs = {
    home-manager.enable = true;
    gpg.enable = true;
    chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  };

  services = {
    gpg-agent.enable = true;
    easyeffects.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  home.stateVersion = "21.11";
}
