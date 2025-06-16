{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
      iconTheme = "Tela-dracula";
      colorScheme = "MonokaiPro";
    };

    fonts = {
      general = {
        family = "Adwaita Sans";
        pointSize = 10;
      };
      menu = {
        family = "Adwaita Sans";
        pointSize = 10;
      };
      small = {
        family = "Adwaita Sans";
        pointSize = 8;
      };
      toolbar = {
        family = "Adwaita Sans";
        pointSize = 10;
      };
      windowTitle = {
        family = "Adwaita Sans";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
    };

    shortcuts = {
      "kwin"."Cycle Overview" = "Meta";
      "services/org.kde.krunner.desktop"."_launch" = "Meta+W";
      "plasmashell"."activate application launcher" = "Meta+A";
      "plasmashell"."next activity" = [ ];
    };

    panels = [
      # Dock
      {
        floating = true;
        height = 56;
        hiding = "dodgewindows";
        lengthMode = "fit";
        location = "bottom";
        screen = 0;
        widgets = [
          {
            iconTasks = {
              launchers = [
                "applications:kitty.desktop"
                "applications:firefox.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:Logseq.desktop"
                "applications:org.gnome.Fractal.desktop"
                "applications:spotify.desktop"
                "applications:discord-canary.desktop"
              ];
            };
          }
        ];
      }
      # Top bar
      {
        floating = false;
        height = 28;
        hiding = "none";
        lengthMode = "fill";
        location = "top";
        screen = 0;
        widgets = [
          "org.kde.plasma.kickoff"
          {
            pager = { };
          }
          "org.kde.plasma.windowlist"
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              date.format = "isoDate";
              date.position = "besideTime";
              time.format = "24h";
            };
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
        ];
      }
    ];
  };
}
