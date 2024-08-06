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

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          pop-shell.extensionUuid
          blur-my-shell.extensionUuid
          gsconnect.extensionUuid
        ];
      };
    };
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

}
