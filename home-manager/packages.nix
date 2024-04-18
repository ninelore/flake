{pkgs, ...}: {
  imports = [
    ./scripts/nx-switch.nix
  ];

  home.packages = with pkgs; with gnome; [
    # cli
    gnutar
    htop
    less
    oh-my-posh
    ranger
    ueberzug
    unar
    w3m
    zip
    unzip

    # gui
    obsidian
    libreoffice
    gimp
    webcord
    thunderbird
    microsoft-edge

    # langs
    nodejs_20
    yarn
    go
    rustup

    # gaming
    lutris
    wine-staging
  ];
}
