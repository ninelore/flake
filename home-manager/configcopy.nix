{ pkgs
, ...
}: {
  xdg.configFile = {
    anyrun.source = ../configs/anyrun;
    #ranger.source = ../configs/ranger;
    kitty.source = ../configs/kitty;
    "hypr/hypridle.conf".source = ../configs/hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ../configs/hypr/hyprlock.conf;
    "microsoft-edge-stable-flags.conf".source = ../configs/chromium-flags.conf;
  };
}
