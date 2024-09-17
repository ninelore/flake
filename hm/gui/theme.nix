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

  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };

  cursorTheme = {
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };
in
{
  home = {
    sessionVariables = {
      QT_WAYLAND_DECORATION = "adwaita";
      #QT_QPA_PLATFORMTHEME = "qt5ct:qt6ct";
    };
    packages = with pkgs; [
      bibata-cursors
      font-awesome
      jetbrains-mono
      material-icons
      nerdfonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      qt6ct
      qt5ct
      qadwaitadecorations
      qadwaitadecorations-qt6
      qgnomeplatform
      qgnomeplatform-qt6
      adwaita-qt
      adwaita-qt6
    ];
    pointerCursor = cursorTheme // {
      gtk.enable = true;
    };
  };

  gtk = {
    inherit
      font
      cursorTheme
      iconTheme
      theme
      ;
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

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Propo" ];
    };
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
}
