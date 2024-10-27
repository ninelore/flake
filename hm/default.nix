{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    ./nix-scripts.nix
    ./sh.nix
  ];

  nixpkgs.config = import ../nix/config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../nix/config.nix;

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    gpg.enable = true;
  };

  services = {
    gpg-agent.enable = true;
  };

  home = {
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
      nixfmt-rfc-style
      pciutils
      picocom
      platformio-core
      unar
      vboot_reference
      zip
      unzip
      usbutils
    ];
  };
}
