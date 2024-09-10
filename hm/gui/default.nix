{ pkgs, ... }:
{
  imports = [
    ./theme.nix
    ./gnome.nix
    ./vscode.nix
  ];

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    };
    obs-studio = {
      enable = true;
    };
  };

  services = {
    kdeconnect.enable = true;
  };

  home.packages = with pkgs; [
    # GUI Apps
    appimage-run
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
    via
    webcord
    wireshark
    ytmdesktop
    zed-editor

    # gayming
    wineWowPackages.stagingFull
    prismlauncher
  ];
}
