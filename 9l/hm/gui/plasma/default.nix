{ pkgs, ... }:
{
  home.packages = with pkgs; [
    adwaita-icon-theme
    bibata-cursors
    tela-icon-theme
  ];

  xdg = {
    dataFile = {
      "color-schemes/MonokaiPro.colors".source = ./MonokaiPro.colors;
    };
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
      };
      iconTheme = "MoreWaita";
      colorScheme = "MonokaiPro";
    };

    # panels = [
    #   # Dock
    #   {
    #     floating = true;
    #     height = 56;
    #     hiding = "dodgewindows";
    #     lengthMode = "fit";
    #     location = "bottom";
    #     screen = "all";
    #     widgets = [
    #       {
    #         iconTasks = {
    #           launchers = [
    #             "applications:kitty.desktop"
    #             "applications:firefox.desktop"
    #             "applications:discord-canary.desktop"
    #             "applications:spotify.desktop"
    #             "applications:org.gnome.Fractal.desktop"
    #             "applications:dev.geopjr.Tuba.desktop"
    #           ];
    #         };
    #       }
    #     ];
    #   }
    #   # Top bar
    #   {
    #     floating = false;
    #     height = 28;
    #     hiding = "none";
    #     lengthMode = "fill";
    #     location = "top";
    #     screen = "all";
    #     widgets = [
    #       "org.kde.plasma.kickoff"
    #       "org.kde.plasma.windowlist"
    #       "org.kde.plasma.panelspacer"
    #       {
    #         digitalClock = {
    #           calendar.firstDayOfWeek = "monday";
    #           date.format = "isoDate";
    #           date.position = "besideTime";
    #           time.format = "24h";
    #         };
    #       }
    #       "org.kde.plasma.panelspacer"
    #       "org.kde.plasma.systemtray"
    #     ];
    #   }
    # ];
  };
}
