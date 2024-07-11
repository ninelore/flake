{ pkgs, ... }:
let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Noto"
    ];
  };

  gtkConf = {
    extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
  font = {
    name = "NotoSans Nerd Font";
    package = nerdfonts;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs.qogir-icon-theme;
  };
  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
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

      adwaita-qt
      adwaita-qt6

      theme.package
      font.package
      cursorTheme.package
      iconTheme.package
      adwaita-icon-theme
    ];
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };
    pointerCursor =
      cursorTheme
      // {
        gtk.enable = true;
      };
    file = {
      ".local/share/themes/${theme.name}" = {
        source = "${theme.package}/share/themes/${theme.name}";
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    inherit font cursorTheme iconTheme;
    theme.name = theme.name;
    enable = true;
    gtk3 = gtkConf;
    gtk4 = gtkConf;
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
    style.package = with pkgs; [
      adwaita-qt
      adwaita-qt6
    ];
  };
}
