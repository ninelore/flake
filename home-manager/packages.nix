{ pkgs, ... }:
let
  edge = pkgs.microsoft-edge.override {
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
    ];
  };
in
{
  imports = [
    ./scripts/nix-helpers.nix
  ];

  home.packages = with pkgs; with gnome; [
    # cli
    btop
    distrobox
    coreboot-utils
    fastfetch
    gnutar
    less
    minicom
    nixpkgs-fmt
    oh-my-posh
    ranger
    unar
    ueberzug
    w3m
    zip
    unzip

    # appimages
    appimage-run

    # gui
    anytype
    obsidian
    vscode-fhs
    libreoffice
    gimp
    webcord
    edge
    protonmail-desktop
    helvum

    # Mail
    #thunderbird
    #protonmail-bridge
    #protonmail-bridge-gui

    # dev
    nodejs_20
    python3
    yarn
    go
    rustup

    # gaming
    #lutris # flatpak
    wineWowPackages.stagingFull
  ];
}
