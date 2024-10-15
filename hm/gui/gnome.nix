{ pkgs, ... }:
{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.alphabetical-app-grid; }
      { package = pkgs.gnomeExtensions.appindicator; }
      { package = pkgs.gnomeExtensions.app-menu-is-back; }
      { package = pkgs.gnomeExtensions.blur-my-shell; }
      { package = pkgs.gnomeExtensions.caffeine; }
      { package = pkgs.gnomeExtensions.clipboard-history; }
      #{ package = pkgs.gnomeExtensions.dash-to-dock; }
      { package = pkgs.gnomeExtensions.gsconnect; }
      { package = pkgs.gnomeExtensions.tiling-shell; }
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
        remember-numlock-state = true;
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          alphabetical-app-grid.extensionUuid
          appindicator.extensionUuid
          app-menu-is-back.extensionUuid
          blur-my-shell.extensionUuid
          caffeine.extensionUuid
          clipboard-history.extensionUuid
          #dash-to-dock.extensionUuid
          gsconnect.extensionUuid
          tiling-shell.extensionUuid
        ];
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
      # Extensions
      "org/gnome/shell/extensions/dash-to-dock" = {
        # Position and Size
        dock-position = "LEFT"; # BOTTOM
        height-fraction = 0.7;
        dock-fixed = false;
        dash-max-icon-size = 42;
        # Launchers
        show-favorites = true;
        isolate-workspaces = false;
        isolate-monitors = false;
        show-windows-preview = true;
        scroll-to-focused-application = true;
        show-show-apps-button = true;
        show-apps-at-top = false;
        animate-show-apps = true;
        show-trash = false;
        show-mounts = false;
        dance-urgent-applications = true;
        hide-tooltip = false;
        show-icons-emblems = true;
        show-icons-notifications-counter = true;
        application-counter-overrides-notifications = true;
        # Behavior
        hot-keys = true;
        hotkeys-overlay = true;
        hotkeys-show-dock = true;
        shortcut = [ "<Super>q" ];
        click-action = "cycle-windows";
        shift-click-action = "previews";
        middle-click-action = "launch";
        shift-middle-click-action = "quit";
        scroll-action = "do-nothing";
        # Appearance
        custom-theme-shrink = true;
        disable-overview-on-startup = false;
        apply-custom-theme = false;
        running-indicator-style = "DASHES";
        custom-background-color = false;
        transparency-mode = "DYNAMIC";
        customize-alphas = false;
      };
      "org/gnome/shell/extensions/tilingshell" = {
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
