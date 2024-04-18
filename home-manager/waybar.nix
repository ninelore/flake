{
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = lib.importJSON ../configs/waybar/config.jsonc;
    style = ../configs/waybar/style.css;
    systemd = {
      enable = true;
      target = "hyprland-session.target"
    }
  }
}