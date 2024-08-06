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
    pointerCursor = cursorTheme // {
      gtk.enable = true;
    };
  };

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

  fonts.fontconfig.enable = true;

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

}
