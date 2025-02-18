{ pkgs, ... }:
let
  gtkConf = {
    extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  font = {
    name = "Cantarell";
    package = pkgs.cantarell-fonts;
  };

  # ignore unused
  theme = {
    name = "adw-gtk3";
    package = pkgs.adw-gtk3;
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
      cantarell-fonts
      dejavu_fonts
      liberation_ttf
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      open-sans
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
      ;
    enable = true;
    gtk3 = gtkConf;
  };

  qt = {
    enable = true;
    style.name = "kvantum-dark";
    style.package = with pkgs; [
      kdePackages.qtsvg
      libsForQt5.qtsvg
      adwaita-kvantum
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
    ];
    platformTheme = {
      name = "adwaita";
    };
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvLibadwaitaDark
    '';
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Cantarell 10" ];
      serif = [ "Cantarell 10" ];
      monospace = [ "JetBrainsMono Nerd Font 11" ];
    };
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
}
