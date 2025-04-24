{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord-canary
    fractal
    prismlauncher
    # protonvpn-cli
    # protonvpn-gui
    tuba
    warcraftlogs
    (pkgs.ghidra.withExtensions (
      p: with p; [
        ghidraninja-ghidra-scripts
        ret-sync
        wasm
      ]
    ))
    (pkgs.retroarch.withCores (
      cores: with cores; [
        melonds
        desmume
        pcsx2
        ppsspp
        vba-m
      ]
    ))
  ];
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };
}
