{ pkgs, ... }:
let
  gtkConf = {
    extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  font = {
    name = "NotoSans Nerd Font";
    package = pkgs.nerdfonts;
  };

  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };
in
{
  home = {
    sessionVariables = {
      #QT_WAYLAND_DECORATION = "adwaita";
      #QT_QPA_PLATFORMTHEME = "qt5ct:qt6ct";
    };
    packages = with pkgs; [
      adw-gtk3
      font-awesome
      jetbrains-mono
      material-icons
      nerdfonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  gtk = {
    inherit
      font
      iconTheme
      ;
    enable = true;
    gtk3 = gtkConf;
  };

  qt = {
    enable = true;
    style.name = "kvantum-dark";
    style.package = with pkgs; [
      adwaita-kvantum
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
      qadwaitadecorations
      qadwaitadecorations-qt6
      qgnomeplatform
      qgnomeplatform-qt6
    ];
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
      monospace = [ "JetBrainsMono Nerd Font Propo" ];
    };
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
}
