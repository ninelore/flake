{ pkgs
, lib
, ...
}: {
  xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
  programs.waybar = {
    enable = true;
    #settings = lib.importJSON ../configs/waybar/config.jsonc; # Not working
    style = ../configs/waybar/style.css;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
  systemd.user.targets = {
    audio = {
      Install = {
        WantedBy = [
          "graphical-session.target"
        ];
      };
      Unit = {
        PartOf = [
          "graphical-session.target"
        ];
        Requires = [
          "pipewire.service"
          "wireplumber.service"
        ];
      };
    };
  };
}
