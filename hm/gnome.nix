{ pkgs, ... }:
{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.alphabetical-app-grid; }
      { package = pkgs.gnomeExtensions.appindicator; }
      { package = pkgs.gnomeExtensions.blur-my-shell; }
      { package = pkgs.gnomeExtensions.dash-to-dock; }
      { package = pkgs.gnomeExtensions.disable-unredirect-fullscreen-windows; }
      { package = pkgs.gnomeExtensions.gsconnect; }
      { package = pkgs.gnomeExtensions.places-status-indicator; }
      { package = pkgs.gnomeExtensions.tiling-shell; }
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
          dash-to-dock.extensionUuid
          gsconnect.extensionUuid
          places-status-indicator.extensionUuid
          tiling-shell.extensionUuid
        ];
      };
      "org/gnome/mutter".experimental-features = [ "scale-monitor-framebuffer" ];
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-up = [ "<Super>Page_Up" ];
        switch-to-workspace-down = [ "<Super>Page_Down" ];
        move-to-workspace-up = [ "<Super><Shift>Page_Up" ];
        move-to-workspace-down = [ "<Super><Shift>Page_Down" ];
      };
    };
  };

  systemd.user.sessionVariables = {
    # GNOME / Wayland bug https://forums.opensuse.org/t/gnome-wayland-session-getting-killed/177667
    MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
  };

  home.packages = with pkgs; [
    eyedropper
    gnome-tweaks
    gradience
    papers
  ];
}
