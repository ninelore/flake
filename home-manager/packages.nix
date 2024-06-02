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

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
    java = {
      enable = true;
      package = pkgs.graalvm-ce;
    };
  };

  home.packages = with pkgs; with gnome; [
    # cli
    android-tools
    btop
    distrobox
    coreboot-utils
    fastfetch
    flyctl
    gnutar
    less
    minicom
    oh-my-posh
    ranger
    unar
    ueberzug
    w3m
    zip
    unzip

    # appimages
    appimage-run

    # gui system tools
    wlr-randr


    # gui
    anytype
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

    # dev
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
    # TODO: define globally available shell envs?
    nodejs_20
    python3
    yarn
    go
    gcc
    rustup
    maven
    quarkus
    visualvm

    # gaming
    #lutris # flatpak
    wineWowPackages.stagingFull
  ];
}
