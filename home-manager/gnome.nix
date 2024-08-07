{ pkgs, ... }: {
  programs.gnome-shell = {
    enable = true;
    extensions = [
      {
        package = pkgs.gnomeExtensions.pop-shell;
      }
      {
        package = pkgs.gnomeExtensions.blur-my-shell;
      }
      {
        package = pkgs.gnomeExtensions.gsconnect;
      }
      {
        package = pkgs.gnomeExtensions.alphabetical-app-grid;
      }
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
          blur-my-shell.extensionUuid
          gsconnect.extensionUuid
          pop-shell.extensionUuid
        ];
      };
      "org/gnome/mutter".experimental-features = [
        "scale-monitor-framebuffer"
      ];
    };
  };

  home.packages = with pkgs; [
    gnome-tweaks
    gradience
  ];
}