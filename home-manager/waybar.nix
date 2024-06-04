{ ... }: {
  xdg.configFile."waybar/config.jsonc".source = ../dots/waybar/config.jsonc;
  programs.waybar = {
    enable = true;
    #package = inputs.waybar.packages.${pkgs.system}.waybar;
    style = ../dots/waybar/style.css;
  };
}
