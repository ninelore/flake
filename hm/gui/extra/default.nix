{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord-canary
    fractal
    prismlauncher
    protonvpn-cli
    protonvpn-gui
    tuba
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
}
