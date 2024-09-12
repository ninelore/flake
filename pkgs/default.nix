{ pkgs, ... }:
{
  eshare = pkgs.callPackage ./eshare { };
  ytmdesktop = pkgs.callPackage ./ytmdesktop { };
  plymouth-bgrt-luks = pkgs.callPackage ./plymouth-bgrt-luks { };
  alsa-ucm-conf-cros = pkgs.callPackage ./alsa-ucm-conf-cros { };
  cros-ectool = pkgs.callPackage ./cros-ectool { };
  #cros-gsctool = pkgs.callPackage ./cros-gsctool { }; # Broken
}
