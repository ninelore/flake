{ pkgs
, lib
, ...
}: {
  xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
  programs.waybar = {
    enable = true;
    style = ../configs/waybar/style.css;
  };
}
