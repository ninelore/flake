{ inputs
, pkgs
, ...
}:
let
  wp = ../assets/wallhaven-r2pmx1.jpg;

  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  plugins = inputs.hyprland-plugins.packages.${pkgs.system};

  hypreventhandler = pkgs.writeShellScript "hypreventhandler" ''
    handle() {
      case $1 in
        monitoradded*) swww img ${wp} ;;
      esac
    }
    socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
  '';

  hyprpowermenu = pkgs.writeShellScript "hyprpowermenu" ''
    op=$(echo -e " Poweroff\n Reboot\n Suspend\n Lock\n Logout" | anyrun --hide-icons true --hide-plugin-info true --show-results-immediately true --plugins libstdin.so | awk '{print tolower($2)}')
    case $op in
    poweroff) ;&
    reboot) ;&
    suspend)
        systemctl "$op"
        ;;
    lock)
        hyprlock
        ;;
    logout)
        hyprctl dispatch exit
        ;;
    esac
  '';

  hyprprodmode = pkgs.writeShellScript "hyprprodmode" ''
    HYPRPRODMODE=$(hyprctl getoption decoration:rounding | awk 'NR==1{print $2}')
    if [ "$HYPRPRODMODE" = 0 ] ; then
      hyprctl --batch "\
        keyword general:gaps_in 5;\
        keyword general:gaps_out "7,10,10,10";\
        keyword decoratiolibreofficen:rounding 10;"
      exit
    fi
    hyprctl reload
  '';

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in
{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    libappindicator
    libappindicator-gtk3
  ];

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

  wayland.windowManager.hyprland = {
    enable = true;
    #package = hyprland;
    systemd.enable = true;
    xwayland.enable = true;
    #plugins = with plugins; [
    #  #hyprexpo
    #];

    settings = {
      exec-once = [
        "waybar"
        "7,10,10,10"
        "swww-daemon"
        "swww img ${wp}"
        "hyprctl setcursor Qogir 24"
        "transmission-gtk"
        "${hypreventhandler}"
        #"protonmail-bridge-gui --no-window"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hypridle"
      ];

      monitor = [
        # Laptops
        "desc:Thermotrex Corporation TL140ADXP01,preferred,auto,1.666667" # GA402R
        "desc:AU Optronics 0x662D, preferred, auto,1.25" # Google Lillipup
        # External
        "desc:HP Inc. HP X34 6CM25210CS,preferred,-1536x-250,1"
        "desc:GWD ARZOPA 000000000000,preferred,1536x0,1.25"
        # Fallback
        ",preferred,auto,auto"
      ];

      general = {
        layout = "dwindle";
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        #"col.active_border" = "rgba(4444ddee) rgba(44dd44ee) rgba(dd4444ee) 30deg";
        "col.active_border" = "rgba(dadadaee)";
        "col.inactive_border" = "rgba(595959aa)";
      };

      misc = {
        disable_splash_rendering = true;
        vfr = true;
      };

      input = {
        kb_layout = "de";
        numlock_by_default = 1;

        follow_mouse = 1;
        accel_profile = "flat";
        sensitivity = 0.8;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          drag_lock = true;
          scroll_factor = 0.5;
          tap-and-drag = true;
        };
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
        # no_gaps_when_only = "yes";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      windowrule =
        let
          f = regex: "float, ^(${regex})$";
        in
        [
          (f "org.gnome.Calculator")
          (f "pavucontrol")
          (f "nm-connection-editor")
          (f "blueberry")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
        ];

      bind =
        let
          binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
          ws = binding "SUPER" "workspace";
          mvtows = binding "SUPER SHIFT" "movetoworkspace";
          arr = [ 1 2 3 4 5 6 7 8 9 ];
        in
        [
          "SUPER, return, exec, kitty"
          "SUPER, E, exec, nautilus"
          "SUPER, D, exec, anyrun"
          "SUPER, L, exec, hyprlock"
          "SUPER, M, exec, ${hyprpowermenu}"
          "SUPER, V, exec, cliphist list | anyrun --hide-icons true --hide-plugin-info true --show-results-immediately true --plugins libstdin.so | cliphist decode | wl-copy"
          "SUPER CTRL, V, exec, cliphist wipe"
          "SUPER SHIFT, S, exec, grimblast copy area"

          "SUPER SHIFT, Q, killactive, "
          "SUPER, space, togglefloating, "
          "SUPER, P, pseudo, "
          "SUPER, O, togglesplit, "
          "SUPER, F, fullscreen,"
          "SUPER, G, exec, ${hyprprodmode}"

          #"SUPER, TAB, hyprexpo:expo, toggle"

          ", XF86ScreenSaver, exec, hyprlock"

          # Example special workspace (scratchpad)
          "SUPER, A, togglespecialworkspace, magic"
          "SUPER SHIFT, A, movetoworkspace, special:magic"


          # WS 11 and 12
          (ws "0" "10")
          (ws "code:20" "11")
          (ws "code:21" "12")
          (mvtows "0" "10")
          (mvtows "code:20" "11")
          (mvtows "code:21" "12")
        ]
        ++ (map (i: ws (toString i) (toString i)) arr)
        ++ (map (i: mvtows (toString i) (toString i)) arr);

      binde =
        let
          binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
          mvfocus = binding "SUPER" "movefocus";
          resizeactive = binding "SUPER CTRL" "resizeactive";
          mvactive = binding "SUPER ALT" "moveactive";
          mvwindow = binding "SUPER SHIFT" "movewindow";
        in
        [
          (mvfocus "k" "u")
          (mvfocus "j" "d")
          (mvfocus "l" "r")
          (mvfocus "h" "l")
          (mvfocus "up" "u")
          (mvfocus "down" "d")
          (mvfocus "right" "r")
          (mvfocus "left" "l")
          (mvwindow "k" "u")
          (mvwindow "j" "d")
          (mvwindow "l" "r")
          (mvwindow "h" "l")
          (mvwindow "up" "u")
          (mvwindow "down" "d")
          (mvwindow "right" "r")
          (mvwindow "left" "l")
          (resizeactive "k" "0 -2%")
          (resizeactive "j" "0 2%")
          (resizeactive "l" "2% 0")
          (resizeactive "h" "-2% 0")
          (resizeactive "up" "0 -2%")
          (resizeactive "down" "0 2%")
          (resizeactive "right" "2% 0")
          (resizeactive "left" "-2% 0")
          (mvactive "k" "0 -2%")
          (mvactive "j" "0 2%")
          (mvactive "l" "2% 0")
          (mvactive "h" "-2% 0")
          (mvactive "up" "0 -2%")
          (mvactive "down" "0 2%")
          (mvactive "right" "2% 0")
          (mvactive "left" "-2% 0")
        ];

      bindle = [
        ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
        ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d *::kbd_backlight set +1"
        ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d *::kbd_backlight set  1-"
        ",XF86AudioRaiseVolume,  exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,  exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ",XF86AudioPlay,    exec, ${playerctl} play-pause"
        ",XF86AudioStop,    exec, ${playerctl} pause"
        ",XF86AudioPause,   exec, ${playerctl} pause"
        ",XF86AudioPrev,    exec, ${playerctl} previous"
        ",XF86AudioNext,    exec, ${playerctl} next"
        ",XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle toggle"
      ];

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      decoration = {
        rounding = 0;
        drop_shadow = false;

        dim_inactive = false;

        blur = {
          enabled = false; # battery concerns
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      #plugin = {
      #  hyprexpo = {
      #    columns = 3;
      #    gap_size = 10;
      #    bg_col = "rgb(232323)";
      #    workspace_method = "first 1";
      #    enable_gesture = true;
      #    gesture_distance = 300;
      #    gesture_positive = false;
      #  };
      #};
    };
  };
}
