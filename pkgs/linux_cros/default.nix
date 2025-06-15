{
  lib,
  fetchurl,
  linuxManualConfig,
  system,
  ...
}:
let
  ver = "6.12.33";
  hash = "sha256-wKV1Yw8mA6ILsGQfjfj5VeRsnXrB+ui1SyExbmtSolQ=";
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
