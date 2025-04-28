{
  lib,
  fetchurl,
  linuxManualConfig,
  system,
  ...
}:
let
  ver = "6.6.87";
  hash = "sha256-iVflwtrNvEehbb8fYwPKcIhAm+YZejiB91IxMnU1esY=";
in
linuxManualConfig rec {
  version = ver + "-sc7180";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
    inherit hash;
  };

  configfile = ./config.aarch64;
  allowImportFromDerivation = builtins.elem system extraMeta.platforms;

  kernelPatches = [
    {
      name = "arm64-dts-qcom-sc7180-Add-tertiary-mi2s-pinctrl";
      patch = ./0002-arm64-dts-qcom-sc7180-Add-tertiary-mi2s-pinctrl.patch;
    }
    {
      name = "arm64-dts-qcom-sc7180-Add-ADSP";
      patch = ./0003-arm64-dts-qcom-sc7180-Add-ADSP.patch;
    }
    {
      name = "ASoC-qcom-sc7180-Add-support-for-qdsp6-baked-sound";
      patch = ./0004-ASoC-qcom-sc7180-Add-support-for-qdsp6-baked-sound.patch;
    }
    {
      name = "arm64-dts-qcom-pm6150-Add-resin-and-rtc-nodes";
      patch = ./0005-arm64-dts-qcom-pm6150-Add-resin-and-rtc-nodes.patch;
    }
    {
      name = "arm64-dts-qcom-acer-aspire1-Enable-RTC";
      patch = ./0006-arm64-dts-qcom-acer-aspire1-Enable-RTC.patch;
    }
    {
      name = "arm64-dts-qcom-acer-aspire1-Add-sound";
      patch = ./0007-arm64-dts-qcom-acer-aspire1-Add-sound.patch;
    }
    {
      name = "platform-Add-ARM64-platform-directory";
      patch = ./0008-platform-Add-ARM64-platform-directory.patch;
    }
    {
      name = "platform-arm64-Add-Acer-Aspire-1-embedded-controller";
      patch = ./0009-platform-arm64-Add-Acer-Aspire-1-embedded-controller.patch;
    }
    {
      name = "arm64-dts-qcom-acer-aspire1-Add-embedded-controller";
      patch = ./0010-arm64-dts-qcom-acer-aspire1-Add-embedded-controller.patch;
    }
  ];

  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
