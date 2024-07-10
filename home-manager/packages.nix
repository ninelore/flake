{ inputs, pkgs, pkgs-small, ... }:
let
  edge = pkgs.microsoft-edge.override {
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
    ];
  };
in
{
  programs = {
    vscode = {
      enable = true;
      package = pkgs-small.vscode;
    };
    java = {
      enable = true;
      package = pkgs.graalvm-ce;
    };
    wezterm = {
      enable = false;
      package = inputs.wezterm.packages."${pkgs.system}".default;
    };
  };

  home.packages = with pkgs; [
    # cli
    btop
    distrobox
    dmidecode
    coreboot-utils
    fastfetch
    flyctl
    gnutar
    gptfdisk
    less
    minicom
    unar
    vboot_reference
    via
    zip
    unzip

    # appimages
    appimage-run

    # gui system tools
    wlr-randr

    # gui
    obsidian
    libreoffice-fresh
    onlyoffice-bin_latest
    gimp
    webcord
    discord
    firefox
    edge
    protonmail-desktop
    helvum
    scrcpy
    wireshark
    #pkgs-small.ytmdesktop
    inputs.ninelore.packages.${pkgs.system}.eshare

    # nix dev
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
    # TODO: define globally available shell envs?
    # C dev
    cmakeCurses
    gcc
    gnumake
    ninja
    # Other dev
    nodejs_20
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
}
