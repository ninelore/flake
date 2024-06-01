{ ... }: {
  xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
  programs.waybar = {
    enable = true;
    #package = inputs.waybar.packages.${pkgs.system}.waybar;
    style = ../configs/waybar/style.css;
  };
}
