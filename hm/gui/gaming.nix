{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher
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
