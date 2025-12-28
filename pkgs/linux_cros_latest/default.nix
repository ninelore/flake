{
  linuxManualConfig,
  linux_6_17,
  system,
  ...
}:
let
  # inherit ((import ../commonSrc.nix { inherit lib fetchurl; }).stable) ver src;
  ver = linux_6_17.version;
  patchList = [
    "mt8183-fix-bluetooth"
    "mt8186-ASoC-hdmi-codec-Add-event-handler-for-hdmi-TX"
    "mt8186-ASoC-mediatek-mt8186-make-FE-nonatomic-and-no_pcm"
    "mt8186-SoC-mediatek-mt8186-correct-the-HDMI-widgets"
    "mt8186-drm-bridge-it6505-Add-audio-support"
    "mt8186-enable-dpi"
  ];
in
linuxManualConfig rec {
  version = ver + "-cros";
  inherit (linux_6_17) src;

  configfile = ./config.aarch64;
  allowImportFromDerivation = builtins.elem system extraMeta.platforms;

  kernelPatches = map (patch: {
    name = patch;
    patch = ../_linuxPatches/${patch}.patch;
  }) patchList;

  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
