{ pkgs
, lib
, ...
}: {
  xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
  programs.waybar = {
    enable = true;
    style = ../configs/waybar/style.css;
  };

  systemd.user = {
    services = {
      waybarc = {
        Install = {
          WantedBy = [
            "graphical-session.target"
          ];
        };
        Service = {
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
          ExecStart = "${pkgs.waybar}/bin/waybar";
          KillMode = "mixed";
          Restart = "on-failure";
        };
        Unit = {
          After = [ "graphical-session-pre.target" ];
          Requires = [ "audio.target" ];
          Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
          Documentation = [ "https://github.com/Alexays/Waybar/wiki" ];
          PartOf = "graphical-session.target";
        };
      };
    };
    targets = {
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
            "easyeffects.service"
          ];
        };
      };
    };
  };
}
