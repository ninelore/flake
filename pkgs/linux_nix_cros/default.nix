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
  version = ver;
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
    inherit hash;
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

  structuredExtraConfig = with lib.kernel; {
    ARCH_MEDIATEK = yes;
    ARCH_QCOM = yes;
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
    #DRM_MEDIATEK = yes;
    #DRM_MEDIATEK_DP = yes;
    #DRM_MEDIATEK_HDMI = yes;

    # Disable unnecessary big stuff
    DRM_NOUVEAU = no;
    DRM_TEGRA = no;
    DRM_AMDGPU = no;
    HSA_AMD = lib.mkForce no;
    FIREWIRE = no;

    # Disable unrelated ARCH_*
    ARCH_ACTIONS = no;
    ARCH_AIROHA = no;
    ARCH_SUNXI = no;
    ARCH_ALPINE = no;
    ARCH_APPLE = no;
    ARCH_BCM = no;
    ARCH_BCM2835 = no;
    ARCH_BCM_IPROC = no;
    ARCH_BCMBCA = no;
    ARCH_BRCMSTB = no;
    ARCH_BERLIN = no;
    ARCH_EXYNOS = no;
    ARCH_SPARX5 = no;
    ARCH_K3 = no;
    ARCH_LG1K = no;
    ARCH_HISI = no;
    ARCH_KEEMBAY = no;
    ARCH_MESON = no;
    ARCH_MVEBU = no;
    ARCH_NXP = no;
    ARCH_LAYERSCAPE = no;
    ARCH_MXC = no;
    ARCH_S32 = no;
    ARCH_MA35 = no;
    ARCH_NPCM = no;
    ARCH_REALTEK = no;
    ARCH_RENESAS = no;
    ARCH_ROCKCHIP = no;
    ARCH_SEATTLE = no;
    ARCH_INTEL_SOCFPGA = no;
    ARCH_STM32 = no;
    ARCH_SYNQUACER = no;
    ARCH_TEGRA = no;
    ARCH_TESLA_FSD = no;
    ARCH_SPRD = no;
    ARCH_THUNDER = no;
    ARCH_THUNDER2 = no;
    ARCH_UNIPHIER = no;
    ARCH_VEXPRESS = no;
    ARCH_VISCONTI = no;
    ARCH_XGENE = no;
    ARCH_ZYNQMP = no;

    # Disable some more
    XEN = lib.mkForce no;
    ATM = no;
    X25 = no;
    LAPB = no;
    PHONET = no;
    ATALK = no;
    TIPC = no;
    ARCNET = no;
    NET_DSA = no;
    FDDI = no;
    HIPPI = lib.mkForce no;
    CAN = no;
    LEGACY_PTYS = no;
    FB_RADEON = no;
    FB_NVIDIA = no;
    PARPORT = no;
  };
  ignoreConfigErrors = true;
}
