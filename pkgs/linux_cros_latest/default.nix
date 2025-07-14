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
  patchList = [
    "arm64-dts-mt8183-Add-kukui-jacuzzi-cerise-board"
    # "arm64-dts-mediatek-Add-dts-for-hayato-rev5-sku0" # FIXME: Conflict in arch/arm64/boot/dts/mediatek/Makefile
    "mt8183-fix-bluetooth"
    "mt8183-kukui-add-it6505-and-enable-dpi"
    "mt8183-kukui-jacuzzi-fix-display-resume"
    "mt8183-kukui-jacuzzi-hack-dpms-resume"
    "mt8183-kukui-jacuzzi-fennel14-rt1015p-sound"
    "wifi-rtw88-Fix-the-random-error-beacon-valid-message"
    "HACK-MTK-Disable-AFBC-support"
    "platform-chrome-cros_ec_typec-Purge-blocking-switch-devlinks"
    # "drm-Display-Add-Type-C-switch-helpers" # TODO: Conflict, check if obsolete
    # "drm-bridge-anx7625-Register-Type-C-mode-switches" # FIXME: Breaks build
    # "drm-bridge-anx7625-Check-for-Type-C-during-panel-registration" # FIXME: Breaks build
    "STOPSHIP-arm64-dts-mediatek-asurada-Add-DP"
    "STOPSHIP-arm64-dts-mediatek-asurada-Enable-HDMI-audio"
    "mt8186-enable-dpi"
    # "mt8186-add-extcon-to-dp-bridge" # INFO: Likely upstreamed
    "mt8195-adsp"
    "mt8195-dvfsrc"
  ];
in
linuxManualConfig rec {
  version = ver + "-cros";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
    inherit hash;
  };

  configfile = ./config.aarch64;
  allowImportFromDerivation = builtins.elem system extraMeta.platforms;

  kernelPatches = builtins.map (patch: {
    name = patch;
    patch = ../_linuxPatches/${patch}.patch;
  }) patchList;

  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
