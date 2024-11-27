{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    ./helix.nix
    ./git.nix
    ./nix-scripts.nix
    ./sh.nix
  ];

  nixpkgs.config = import ../nix/config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../nix/config.nix;

  programs = {
    home-manager.enable = true;
    broot.enable = true;
    direnv.enable = true;
    gpg.enable = true;
    jq.enable = true;
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
      chafa
      coreboot-utils
      curl
      devenv
      distrobox
      dmidecode
      fastfetch
      flyctl
      gnutar
      gptfdisk
      less
      nixfmt-rfc-style
      pciutils
      picocom
      platformio-core
      starship # Distrobox fix
      tldr
      unar
      vboot_reference
      zip
      unzip
      usbutils
      weechat
    ];
  };
}
