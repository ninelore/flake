{ inputs, pkgs, ... }:
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

  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };

  cursorTheme = {
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  hyprcursorTheme = {
    name = "Bibata-modern";
    package = inputs.niqspkgs.packages.${pkgs.system}.bibata-hyprcursor.override {
      baseColor = "#FFFFFF";
      outlineColor = "#000000";
      watchBackgroundColor = "#FFFFFF";
    };
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
      font.package # Nerd Fonts
    ];
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
      HYPRCURSOR_THEME = hyprcursorTheme.name;
      HYPRCURSOR_SIZE = "${toString cursorTheme.size}";
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };
    pointerCursor = cursorTheme // {
      gtk.enable = true;
    };
    file = {
      ".icons/${hyprcursorTheme.name}".source = "${hyprcursorTheme.package}/share/icons/${hyprcursorTheme.name}";
    };
  };

  xdg.dataFile = {
    "icons/${hyprcursorTheme.name}".source = "${hyprcursorTheme.package}/share/icons/${hyprcursorTheme.name}";
    "themes/${theme.name}".source = "${theme.package}/share/themes/${theme.name}";
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
