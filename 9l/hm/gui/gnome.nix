{ lib, pkgs, ... }:
let
  extensionList = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    app-menu-is-back
    blur-my-shell
    brightness-control-using-ddcutil
    caffeine
    clipboard-history
    gsconnect
    hot-edge
    nightscout
    quick-settings-audio-devices-hider
    quick-settings-audio-devices-renamer
    tiling-shell
    vitals
    wiggle
  ];

  cursorTheme = {
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };
in
{
  programs.gnome-shell = {
    enable = true;
    extensions = builtins.map (ext: { package = ext; }) extensionList;
  };
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
        favorite-apps = [
          "kitty.desktop"
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "discord-canary.desktop"
          "spotify.desktop"
          "org.gnome.Fractal.desktop"
          "dev.geopjr.Tuba.desktop"
          "startcenter.desktop"
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
      "org/gnome/shell/extensions/display-brightness-ddcutil" = {
        button-location = 1;
        ddcutil-queue-ms = 500.0;
        ddcutil-sleep-multiplier = 80.0;
        show-osd = true;
        show-display-name = true;
        hide-system-indicator = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        override-background = true;
        override-background-dynamically = true;
      };
    };
  };

  home = {
    packages = with pkgs; [
      # Apps
      eyedropper
      gnome-maps
      papers
      refine
      # Theme stuff
      adw-gtk3
      # Fonts
      adwaita-fonts
      cantarell-fonts
      dejavu_fonts
      liberation_ttf
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
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
    inherit cursorTheme;
    enable = true;
    iconTheme = {
      name = "Tela-dracula";
      package = pkgs.tela-icon-theme;
    };
    font = {
      name = "Adwaita Sans";
      package = pkgs.adwaita-fonts;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum-dark";
    style.package = with pkgs; [
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
      sansSerif = [ "Adwaita Sans 11" ];
      serif = [ "Adwaita Sans 11" ];
      monospace = [ "JetBrainsMono Nerd Font 11" ];
    };
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

  # systemd.user.sessionVariables = {
  #   # GNOME / Wayland bug https://forums.opensuse.org/t/gnome-wayland-session-getting-killed/177667
  #   MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
  # };
}
