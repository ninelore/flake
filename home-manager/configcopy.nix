{ pkgs
, ...
}: {
  xdg.configFile = {
    anyrun.source = ../configs/anyrun;
    #ranger.source = ../configs/ranger;
    kitty.source = ../configs/kitty;
    "hypr/hypridle.conf".source = ../configs/hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ../configs/hypr/hyprlock.conf;
    "edge-flags.conf".source = ../configs/chromium-flags.conf;
    "microsoft-edge-stable-flags.conf".source = ../configs/chromium-flags.conf;
  };

  #home.file = {
  #  ".var/app/com.microsoft.Edge/config/edge-flags.conf".source = ../configs/chromium-flags.conf;
  #  ".var/app/com.microsoft.Edge/config/microsoft-edge-stable-flags.conf".source = ../configs/chromium-flags.conf;
  #};
}
