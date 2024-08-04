{ inputs, pkgs, ... }:
let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Noto"
    ];
  };
in
{
  home = {
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      jetbrains-mono
      nerdfonts
      material-icons
      bibata-cursors
      materia-kde-theme
      materia-theme
    ];
  };

  fonts.fontconfig.enable = true;

  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs.plasma = {
    enable = true;

    workspace = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
      };
    };

    panels = [
      {
        height = 30;
        location = "top";
        floating = true;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          { name = "org.kde.plasma.marginsseparator"; }
          {
            iconTasks = {
              launchers = [
                "applications:kitty.desktop"
                "applications:firefox.desktop"
              ];
            };
          }
          { name = "org.kde.plasma.appmenu"; }
          { name = "org.kde.plasma.panelspacer"; }
          {
            digitalClock = {
              date = {
                enable = true;
                position = "besideTime";
                format = {
                  custom = "ddd yyyy-MM-dd ";
                };
              };
            };
          }
          { name = "org.kde.plasma.panelspacer"; }
          { name = "org.kde.plasma.pager"; }
          { systemTray = { }; }
        ];
      }
    ];

    fonts = {
      general = {
        family = "NotoSans Nerd Font Propo";
        pointSize = 10;
      };
      small = {
        family = "NotoSans Nerd Font Propo";
        pointSize = 8;
      };
      toolbar = {
        family = "NotoSans Nerd Font Propo";
        pointSize = 10;
      };
      menu = {
        family = "NotoSans Nerd Font Propo";
        pointSize = 10;
      };
      windowTitle = {
        family = "NotoSans Nerd Font Propo";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font Propo";
        pointSize = 10;
      };
    };
  };
}
