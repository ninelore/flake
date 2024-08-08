{ pkgs, ... }:
{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.alphabetical-app-grid; }
      { package = pkgs.gnomeExtensions.appindicator; }
      { package = pkgs.gnomeExtensions.blur-my-shell; }
      { package = pkgs.gnomeExtensions.pop-shell; }
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          alphabetical-app-grid.extensionUuid
          appindicator.extensionUuid
          blur-my-shell.extensionUuid
          pop-shell.extensionUuid
        ];
      };
      "org/gnome/mutter".experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };

  home.packages = with pkgs; [
    gnome-tweaks
    gradience
  ];
}
