{
  lib,
  callPackage,
  fetchurl,
  linuxManualConfig,
  ...
}:
let
  ver = "6.12.24";
  hash = "sha256-ZDFCwbWZFWDdEvlQglzBnkSXuVuCZBkY7P8Rd/QTDB0=";
in
linuxManualConfig {
  version = ver + "-mt81";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
    inherit hash;
  };

  configfile = ./config.aarch64;
  config = callPackage ../kconfigToNix.nix { };

  kernelPatches = [
    {
      name = "mt8183-fix-bluetooth";
      patch = ./mt8183-fix-bluetooth.patch;
    }
    {
      name = "mt8183-kukui-add-it6505-and-enable-dpi";
      patch = ./mt8183-kukui-add-it6505-and-enable-dpi.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-fennel14-rt1015p-sound";
      patch = ./mt8183-kukui-jacuzzi-fennel14-rt1015p-sound.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-fix-display-resume";
      patch = ./mt8183-kukui-jacuzzi-fix-display-resume.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-hack-dpms-resume";
      patch = ./mt8183-kukui-jacuzzi-hack-dpms-resume.patch;
    }
    {
      name = "mt8195-adsp";
      patch = ./mt8195-adsp.patch;
    }
    {
      name = "mt8195-cherry-tomato-nvme";
      patch = ./mt8195-cherry-tomato-nvme.patch;
    }
    {
      name = "mt8195-dvfsrc";
      patch = ./mt8195-dvfsrc.patch;
    }
  ];

  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
