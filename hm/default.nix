{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    ./nix-scripts.nix
    ./sh.nix
    ./theme.nix
    ./gnome.nix
  ];

  news.display = "show";

  xdg.configFile = {
    "libvirt/qemu.conf".text = ''
      nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
    '';
  };

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    gpg.enable = true;
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    };
    vscode = {
      enable = true;
      package = pkgs.pkgs-small.vscode;
    };
    java = {
      enable = true;
      package = pkgs.graalvm-ce;
    };

  };

  services = {
    gpg-agent.enable = true;
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      GDK_BACKEND = "wayland,x11";
      #GDK_SCALE = 1.25;
      #GDK_DPI_SCALE = 1;
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

    packages = with pkgs; [
      # cli
      android-studio-tools
      android-tools
      btop
      comma
      devenv
      distrobox
      dmidecode
      coreboot-utils
      fastfetch
      flyctl
      gnutar
      gptfdisk
      less
      minicom
      nixd
      nixfmt-rfc-style
      unar
      vboot_reference
      via
      zip
      wlr-randr
      unzip

      # appimages
      appimage-run

      # gui
      eshare
      firefox
      gimp
      helvum
      jetbrains-toolbox
      libreoffice-fresh
      obsidian
      textpieces
      onlyoffice-bin_latest
      protonmail-bridge-gui
      protonvpn-gui
      scrcpy
      webcord
      wireshark
      ytmdesktop

      # dev
      cmakeCurses
      gcc
      gnumake
      ninja
      nodejs_22
      python3
      yarn
      go
      rustup
      maven
      quarkus
      visualvm

      # gaming
      #lutris # flatpak
      wineWowPackages.stagingFull
    ];
  };
}
