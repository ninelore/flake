{ pkgs, inputs, config, ...
}: {
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  programs.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    polkit.enable = true;
  };

  environment.systemPackages = with pkgs;
    with gnome; [
      adwaita-icon-theme
      adw-gtk3
      anyrun
      blueberry
      brightnessctl
      cliphist
      evince
      file-roller
      gnome-boxes
      gnome-calculator
      gnome-connections
      gnome-software # for flatpak
      grimblast
      hypridle
      hyprlock
      kitty
      loupe
      mako
      nautilus
      pavucontrol
      sushi
      swww
      wev
      wl-clipboard
    ];

  services = {
    gvfs.enable = true;
    #devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
  };
}
