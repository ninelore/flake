{ pkgs, ... }:
let
  gtkConf = {
    extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  font = {
    name = "Noto Sans";
    package = pkgs.noto-fonts;
  };

  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };
in
{
  home = {
    packages = with pkgs; [
      adw-gtk3
      font-awesome
      jetbrains-mono
      material-icons
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
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
