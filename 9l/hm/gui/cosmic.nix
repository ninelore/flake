{
  cosmicLib,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      adw-gtk3
      tela-icon-theme
    ];
    pointerCursor = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };

  # Undocumented: `adw-gtk3` is the recommended way by upstream to apply theming to GTK3
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name="adw-gtk3"
  '';

  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdeconnect-kde_git;
  };

  programs = {
    cosmic-ext-ctl.enable = true;
    cosmic-manager.enable = true;
    cosmic-ext-tweaks.enable = true;
  };

  wayland.desktopManager.cosmic = {
    enable = true;
    compositor = {
      state = cosmicLib.cosmic.mkRON "enum" "Enabled";
      autotile_behavior = cosmicLib.cosmic.mkRON "enum" "PerWorkspace";
      keyboard_config.numlock_state = cosmicLib.cosmic.mkRON "enum" "BootOn";
      workspaces = {
        workspace_layout = cosmicLib.cosmic.mkRON "enum" "Horizontal";
        workspace_mode = cosmicLib.cosmic.mkRON "enum" "OutputBound";
      };
      input_default = {
        state = cosmicLib.cosmic.mkRON "enum" "Enabled";
        acceleration = cosmicLib.cosmic.mkRON "optional" {
          profile = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "Flat");
          speed = 0.0;
        };
      };
      input_touchpad = {
        state = cosmicLib.cosmic.mkRON "enum" "Enabled";
        click_method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "Clickfinger");
        scroll_config = cosmicLib.cosmic.mkRON "optional" {
          method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "TwoFinger");
          natural_scroll = cosmicLib.cosmic.mkRON "optional" true;
          scroll_button = cosmicLib.cosmic.mkRON "optional" null;
          scroll_factor = cosmicLib.cosmic.mkRON "optional" null;
        };
        tap_config = cosmicLib.cosmic.mkRON "optional" {
          enabled = true;
          button_map = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "LeftRightMiddle");
          drag = true;
          drag_lock = false;
        };
      };
      accessibility_zoom = {
        start_on_login = false;
        enable_mouse_zoom_shortcuts = false;
        increment = 50;
        show_overlay = true;
        view_moves = cosmicLib.cosmic.mkRON "enum" "Continuously";
      };
    };
    applets = {
      app-list.settings = {
        enable_drag_source = true;
        favorites = [
          "kitty"
          "firefox"
          "com.system76.CosmicFiles"
          "org.gnome.Fractal"
          "spotify"
          "discord-canary"
        ];
      };
    };
    panels = [
      {
        anchor = cosmicLib.cosmic.mkRON "enum" "Top";
        anchor_gap = false;
        autohide = cosmicLib.cosmic.mkRON "optional" null;
        expand_to_edges = true;
        name = "Panel";
        opacity = 1.0;
        output = cosmicLib.cosmic.mkRON "enum" "All";
        size = cosmicLib.cosmic.mkRON "enum" "XS";
        plugins_wings = cosmicLib.cosmic.mkRON "optional" (
          cosmicLib.cosmic.mkRON "tuple" [
            [
              "com.system76.CosmicAppletWorkspaces"
            ]
            [
              "com.system76.CosmicAppletStatusArea"
              "com.system76.CosmicAppletInputSources"
              "com.system76.CosmicAppletTiling"
              "com.system76.CosmicAppletBluetooth"
              "com.system76.CosmicAppletNetwork"
              "com.system76.CosmicAppletAudio"
              "com.system76.CosmicAppletBattery"
              "com.system76.CosmicAppletPower"
            ]
          ]
        );
        plugins_center = cosmicLib.cosmic.mkRON "optional" [
          "com.system76.CosmicAppletTime"
          "com.system76.CosmicAppletNotifications"
        ];
      }
      {
        anchor = cosmicLib.cosmic.mkRON "enum" "Bottom";
        anchor_gap = true;
        autohide = cosmicLib.cosmic.mkRON "optional" {
          handle_size = 4;
          transition_time = 200;
          wait_time = 1000;
        };
        expand_to_edges = false;
        name = "Dock";
        opacity = 0.7;
        output = cosmicLib.cosmic.mkRON "enum" "All";
        size = cosmicLib.cosmic.mkRON "enum" "L";
        plugins_center = cosmicLib.cosmic.mkRON "optional" [
          "com.system76.CosmicAppList"
          "com.system76.CosmicPanelAppButton"
        ];
        plugins_wings = cosmicLib.cosmic.mkRON "optional" null;
      }
    ];
    appearance = {
      theme.mode = "dark";
      toolkit = {
        apply_theme_global = true;
        icon_theme = "Tela-dracula";
        interface_font = {
          family = "Inter";
          stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
          style = cosmicLib.cosmic.mkRON "enum" "Normal";
          weight = cosmicLib.cosmic.mkRON "enum" "Normal";
        };
        monospace_font = {
          family = "JetBrainsMono Nerd Font";
          stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
          style = cosmicLib.cosmic.mkRON "enum" "Normal";
          weight = cosmicLib.cosmic.mkRON "enum" "Normal";
        };
        show_maximize = false;
        show_minimize = true;
      };
      theme.dark = {
        accent = cosmicLib.cosmic.mkRON "optional" {
          blue = cosmicLib.cosmic.mkRON "raw" "0.38682923";
          green = cosmicLib.cosmic.mkRON "raw" "0.25607735";
          red = cosmicLib.cosmic.mkRON "raw" "0.96926916";
        };
        bg_color = cosmicLib.cosmic.mkRON "optional" {
          alpha = cosmicLib.cosmic.mkRON "raw" "1.0";
          blue = cosmicLib.cosmic.mkRON "raw" "0.03529412";
          green = cosmicLib.cosmic.mkRON "raw" "0.03529412";
          red = cosmicLib.cosmic.mkRON "raw" "0.03529412";
        };
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "xdgdesktopportal";
  };
}
