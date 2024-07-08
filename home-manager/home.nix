{ pkgs, config, ... }: {
  imports = [
    ./git.nix
    ./hyprland.nix
    ./nix-scripts.nix
    ./packages.nix
    ./sh.nix
    ./theme.nix
  ];

  news.display = "show";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  xdg.configFile = {
    "kitty".source = ../dots/kitty;
    "wezterm".source = ../dots/wezterm;
    "libvirt/qemu.conf".source = pkgs.writeText "qemu.conf" ''
      nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
    '';
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
      SWWW_TRANSITION_STEP = 255;
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/chromium-dev/depot_tools"
      "$HOME/go/bin"
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
    direnv.enable = true;
    home-manager.enable = true;
    gpg.enable = true;
    chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  };

  services = {
    gpg-agent.enable = true;
    easyeffects.enable = true;
    gnome-keyring.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  home.stateVersion = "21.11";
}
