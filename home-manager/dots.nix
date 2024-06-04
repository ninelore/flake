{ ... }: {
  xdg.configFile = {
    "anyrun".source = ../dots/anyrun;
    "kitty".source = ../dots/kitty;
    "hypr/hypridle.conf".source = ../dots/hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ../dots/hypr/hyprlock.conf;
    "wezterm".source = ../dots/wezterm;
  };
}
