{
  lib,
  fetchurl,
  linuxManualConfig,
  system,
  ...
}:
let
  ver = "6.15.6";
  hash = "sha256-K7WGyVQnfQcMj99tcnX6qTtIB9m/M1O0kdgUnMoCtPw=";
in
linuxManualConfig rec {
  version = ver + "-cros";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
    inherit hash;
  };

  configfile = ./config.aarch64;
  allowImportFromDerivation = builtins.elem system extraMeta.platforms;

  kernelPatches = [
    {
      name = "mt8183-fix-bluetooth";
      patch = ../linux_cros/mt8183-fix-bluetooth.patch;
    }
    {
      name = "mt8183-kukui-add-it6505-and-enable-dpi";
      patch = ../linux_cros/mt8183-kukui-add-it6505-and-enable-dpi.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-fennel14-rt1015p-sound";
      patch = ../linux_cros/mt8183-kukui-jacuzzi-fennel14-rt1015p-sound.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-fix-display-resume";
      patch = ../linux_cros/mt8183-kukui-jacuzzi-fix-display-resume.patch;
    }
    {
      name = "mt8183-kukui-jacuzzi-hack-dpms-resume";
      patch = ../linux_cros/mt8183-kukui-jacuzzi-hack-dpms-resume.patch;
    }
    {
      name = "mt8195-adsp";
      patch = ../linux_cros/mt8195-adsp.patch;
    }
    {
      name = "mt8195-cherry-tomato-nvme";
      patch = ../linux_cros/mt8195-cherry-tomato-nvme.patch;
    }
    {
      name = "mt8195-dvfsrc";
      patch = ../linux_cros/mt8195-dvfsrc.patch;
    }
  ];

  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
