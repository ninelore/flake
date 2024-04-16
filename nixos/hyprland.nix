{
  pkgs,
  inputs,
  config
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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

  environment.systemPackages = with pkgs; # TODO
  with gnome; [
    adwaita-icon-theme
    adw-gtk3
    anyrun
    blueberry
    cliphist
    gnome.file-roller
    grimblast
    hypridle
    hyprlock
    kitty
    mako
    qadwaitadecorations
    qadwaitadecorations-qt6    
    #
    themechanger
    #
    loupe
    nautilus
    baobab
    gnome-text-editor
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    gnome-weather
    gnome-calculator
    gnome-clocks
    gnome-software # for flatpak
    wl-gammactl
    wl-clipboard
    wayshot
    pavucontrol
    brightnessctl
    swww
  ];

  programs.[
    light
  ].enable

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