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

  environment.systemPackages = with pkgs;
  with gnome; [
    adwaita-icon-theme
    adw-gtk3
    anyrun
    blueberry
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
    microsoft-edge
    nautilus
    pavucontrol
    sushi
    swww
    wev
    wl-clipboard
  ];

  programs = {
    light.enable = true;
    waybar.enable = true;
  };

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