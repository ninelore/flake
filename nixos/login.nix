{ config, lib, pkgs, ... }:
let
  wp = ../assets/wallhaven-r2pmx1.jpg;
in
{
  services.greetd = {
    enable = true;
    settings = {
      
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "${wp}";
        fit = "Cover";
        # color = "#282a36";
      };
      GTK = {
        theme_name = "adw-gtk3-dark";
        application_prefer_dark_theme = true;
      };
    };
  };
}
