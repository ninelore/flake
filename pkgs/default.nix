{ pkgs, ... }:
{
  eshare = pkgs.callPackage ./eshare { };
  ytmdesktop = pkgs.callPackage ./ytmdesktop { };
  plymouth-bgrt-luks = pkgs.callPackage ./plymouth-bgrt-luks { };
  cb-ucm-conf = pkgs.callPackage ./alsa-ucm-conf-cros { };
}
