{
  lib,
  fetchurl,
  linuxManualConfig,
  system,
  ...
}:
let
  ver = "6.12.25";
  hash = "sha256-yK94D29hPKJGIhFuTFEqdkM1q2bnXGZDADwW5JqOO5A=";
in
linuxManualConfig rec {
  version = ver + "-mt81";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
    inherit hash;
  };

  configfile = ./config.aarch64;
  allowImportFromDerivation = builtins.elem system extraMeta.platforms;

  kernelPatches = [
    {
      name = "mt8183-fix-bluetooth";
      patch = ../linuxPatches/mt8183-fix-bluetooth.patch;
    }
    {
      name = "mt8183-kukui-add-it6505-and-enable-dpi";
      patch = ../linuxPatches/mt8183-kukui-add-it6505-and-enable-dpi.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-fennel14-rt1015p-sound";
      patch = ../linuxPatches/mt8183-kukui-jacuzzi-fennel14-rt1015p-sound.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-fix-display-resume";
      patch = ../linuxPatches/mt8183-kukui-jacuzzi-fix-display-resume.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-hack-dpms-resume";
      patch = ../linuxPatches/mt8183-kukui-jacuzzi-hack-dpms-resume.patch;
    }
    {
      name = "mt8195-adsp";
      patch = ../linuxPatches/mt8195-adsp.patch;
    }
    {
      name = "mt8195-cherry-tomato-nvme";
      patch = ../linuxPatches/mt8195-cherry-tomato-nvme.patch;
    }
    {
      name = "mt8195-dvfsrc";
      patch = ../linuxPatches/mt8195-dvfsrc.patch;
    }
  ];

  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
