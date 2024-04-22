{pkgs, ...}: {
  imports = [
    ./scripts/nx-switch.nix
  ];

  home.packages = with pkgs; with gnome; [
    # cli
    btop
    gnutar
    fastfetch
    less
    minicom
    neofetch
    nixpkgs-fmt
    oh-my-posh
    ranger
    unar
    ueberzug
    w3m
    zip
    unzip

    # gui
    obsidian
    vscode-fhs
    libreoffice
    gimp
    webcord
    microsoft-edge
    protonmail-desktop

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
