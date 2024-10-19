{ pkgs, ... }:
with pkgs;
{
  eshare = callPackage ./eshare { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  cros-ectool = callPackage ./cros-ectool { };
  #cros-gsctool = callPackage ./cros-gsctool { }; # Broken
}
