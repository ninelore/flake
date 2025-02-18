{ pkgs, ... }:
{
  imports = [
    ../../cli
    ../theme.nix
    ../gnome.nix
  ];

  home = {
    packages = with pkgs; [
      appimage-run
      ptyxis
      wl-clipboard
    ];
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = 1;
      NIXOS_OZONE_WL = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_ENABLE_HIGHDPI_SCALING = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
