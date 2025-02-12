{ lib, pkgs, ... }:
let
  extensionList = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    app-menu-is-back
    caffeine
    clipboard-history
    nightscout
    tiling-shell
    vitals
  ];
in
{
  programs.gnome-shell = {
    enable = true;
    extensions = builtins.map (ext: { package = ext; }) extensionList;
  };

  home.packages = with pkgs; [
    adw-gtk3
  ];

  dconf = {
    enable = true;
    settings = with lib.hm.gvariant; {
      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
        remember-numlock-state = true;
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = builtins.map (ext: ext.extensionUuid) extensionList;
      };
      "org/gnome/desktop/input-sources" = {
        xkb-options = [
          "terminate:ctrl_alt_bksp"
          "numpad:mac"
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
        click-method = "fingers";
        natural-scroll = true;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "icon:minimize,close";
      };
      "org/gnome/desktop/interface" = {
        gtk-theme = "adw-gtk3";
      };
      # Extensions
      "org/gnome/shell/extensions/tilingshell" = {
        show-indicator = false;
        active-screen-edges = false;
        layouts-json = builtins.readFile ./tilingshell.json;
        enable-move-keybindings = false;
      };
      "org/gnome/shell/extensions/clipboard-history" = {
        window-width-percentag = 30;
        history-size = 100;
        cache-size = 100;
        cache-only-favorites = false;
        move-item-first = true;
        strip-text = true;
        paste-on-selection = false;
        process-primary-selection = false;
        display-mode = 0;
        disable-down-arrow = true;
        confirm-clear = true;
        enable-keybindings = false;
      };
      "org/gnome/shell/extensions/nightscout" = {
        notification-out-of-range = true;
        notification-stale-data = true;
        notification-rapidly-changes = false;
        notification-urgency-level = 2;
      };
      "org/gnome/shell/extensions/vitals" = {
        hot-sensors = [ "_default_icon_" ];
        icon-style = 1;
      };
    };
  };

  systemd.user.sessionVariables = {
    # GNOME / Wayland bug https://forums.opensuse.org/t/gnome-wayland-session-getting-killed/177667
    MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
  };
}
