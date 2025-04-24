{
  buildLinux,
  fetchurl,
  lib,
  ...
}:
let
  ver = "6.12.24";
  hash = "sha256-ZDFCwbWZFWDdEvlQglzBnkSXuVuCZBkY7P8Rd/QTDB0=";
in
buildLinux rec {
  version = ver + "-mt81";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
    inherit hash;
  };

  structuredExtraConfig = with lib.kernel; {
    #SPI_MTK_NOR = yes;
    MTK_HSDMA = yes;
    MTK_CQDMA = yes;
    MTK_CMDQ = yes;
    MTK_MMSYS = yes;
    MTK_SVS = yes;
    PWM_MTK_DISP = yes;
    PWM_MEDIATEK = yes;
    PHY_MTK_PCIE = yes;
    PHY_MTK_HDMI = yes;
    PHY_MTK_MIPI_DSI = yes;
    PHY_MTK_DP = yes;
    INTERCONNECT_MTK = yes;
    DRM_MEDIATEK = yes;
    DRM_MEDIATEK_DP = yes;
    DRM_MEDIATEK_HDMI = yes;
  };

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
