{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    ./nix-scripts.nix
    ./sh.nix
  ];

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    gpg.enable = true;
    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };

  services = {
    gpg-agent.enable = true;
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      ZELLIJ_AUTO_ATTACH = "true";
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/chromium-dev/depot_tools"
      "$HOME/go/bin"
    ];

    packages = with pkgs; [
      # cli
      android-tools
      btop
      comma
      curl
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
      neovim
      nix-index
      nixd
      nixfmt-rfc-style
      pciutils
      ranger
      unar
      vboot_reference
      zip
      unzip
      usbutils

      # TODO: dev stuff in config meh

      # build tools and managers
      android-studio-tools
      clang-tools
      cmakeCurses
      gdb
      gnumake
      lldb
      maven
      ninja
      openocd
      platformio-core
      pkg-config
      quarkus
      rustup
      vcpkg
      yarn

      # Language toolchains
      gcc
      go
      nodejs
      python3
    ];
  };
}
