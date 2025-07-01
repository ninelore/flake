{
  lib,
  fetchurl,
  linuxManualConfig,
  system,
  ...
}:
let
  ver = "6.15.4";
  hash = "sha256-Dq/WJ7YC9Y1zkX0A5PwxlroYy6Z99plaQqp0dE2O+hY=";
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
      name = "HACK-MTK-Disable-AFBC-support";
      patch = ../linux_cros/HACK-MTK-Disable-AFBC-support.patch;
    }
    {
      name = "STOPSHIP-arm64-dts-mediatek-asurada-Add-DP";
      patch = ../linux_cros/STOPSHIP-arm64-dts-mediatek-asurada-Add-DP.patch;
    }
    {
      name = "STOPSHIP-arm64-dts-mediatek-asurada-Enable-HDMI-audio";
      patch = ../linux_cros/STOPSHIP-arm64-dts-mediatek-asurada-Enable-HDMI-audio.patch;
    }
    {
      name = "arm64-dts-mediatek-Add-dts-for-hayato-rev5-sku0";
      patch = ../linux_cros/arm64-dts-mediatek-Add-dts-for-hayato-rev5-sku0.patch;
    }
    {
      name = "arm64-dts-mt8183-Add-kukui-jacuzzi-cerise-board";
      patch = ../linux_cros/arm64-dts-mt8183-Add-kukui-jacuzzi-cerise-board.patch;
    }
    {
      name = "drm-Display-Add-Type-C-switch-helpers";
      patch = ../linux_cros/drm-Display-Add-Type-C-switch-helpers.patch;
    }
    {
      name = "drm-bridge-anx7625-Check-for-Type-C-during-panel-registration";
      patch = ../linux_cros/drm-bridge-anx7625-Check-for-Type-C-during-panel-registration.patch;
    }
    {
      name = "drm-bridge-anx7625-Register-Type-C-mode-switches";
      patch = ../linux_cros/drm-bridge-anx7625-Register-Type-C-mode-switches.patch;
    }
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
      name = "mt8186-add-extcon-to-dp-bridge";
      patch = ../linux_cros/mt8186-add-extcon-to-dp-bridge.patch;
    }
    {
      name = "mt8186-enable-dpi";
      patch = ../linux_cros/mt8186-enable-dpi.patch;
    }
    {
      name = "mt8195-adsp";
      patch = ../linux_cros/mt8195-adsp.patch;
    }
    {
      name = "mt8195-dvfsrc";
      patch = ../linux_cros/mt8195-dvfsrc.patch;
    }
    {
      name = "platform-chrome-cros_ec_typec-Purge-blocking-switch-devlinks";
      patch = ../linux_cros/platform-chrome-cros_ec_typec-Purge-blocking-switch-devlinks.patch;
    }
    {
      name = "wifi-rtw88-Fix-the-random-error-beacon-valid-message";
      patch = ../linux_cros/wifi-rtw88-Fix-the-random-error-beacon-valid-message.patch;
    }
  ];

  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
