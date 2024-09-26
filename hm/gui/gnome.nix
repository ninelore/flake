{ pkgs, ... }:
{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.alphabetical-app-grid; }
      { package = pkgs.gnomeExtensions.appindicator; }
      { package = pkgs.gnomeExtensions.app-menu-is-back; }
      { package = pkgs.gnomeExtensions.caffeine; }
      { package = pkgs.gnomeExtensions.clipboard-history; }
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
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          alphabetical-app-grid.extensionUuid
          appindicator.extensionUuid
          app-menu-is-back.extensionUuid
          caffeine.extensionUuid
          clipboard-history.extensionUuid
          dash-to-dock.extensionUuid
          gsconnect.extensionUuid
          places-status-indicator.extensionUuid
          tiling-shell.extensionUuid
        ];
      };
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-up = [ "<Super>Page_Up" ];
        switch-to-workspace-down = [ "<Super>Page_Down" ];
        move-to-workspace-up = [ "<Super><Shift>Page_Up" ];
        move-to-workspace-down = [ "<Super><Shift>Page_Down" ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = true;
        show-battery-percentage = true;
      };
      "org/gnome/shell/app-switcher" = {
        current-workspace-only = false;
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = true;
        experimental-features = [ "scale-monitor-framebuffer" ];
        workspaces-only-on-primary = true;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        accel-profile = "flat";
        click-method = "fingers";
        natural-scroll = true;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "icon:minimize,close";
      };
      "org/gnome/desktop/interface" = {
        gtk-theme = "adw-gtk3";
        font-name = "NotoSans Nerd Font 10";
        document-font-name = "Cantarell 11";
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
