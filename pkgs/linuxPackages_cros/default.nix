{
  lib,
  linuxPackagesFor,
  linuxKernel,
  ...
}:

let
  kernel = linuxKernel.kernels.linux_6_12.override {
    structuredExtraConfig = with lib.kernel; {
      ARCH_MEDIATEK = "y";
      ARM_MEDIATEK_CPUFREQ = "y";
      ARM_MEDIATEK_CPUFREQ_HW = "y";
      PCIE_MEDIATEK = "y";
      PCIE_MEDIATEK_GEN3 = "y";
      NET_VENDOR_MEDIATEK = "y";
      VIDEO_MEDIATEK_JPEG = "y";
      VIDEO_MEDIATEK_MDP = "m";
      VIDEO_MEDIATEK_VCODEC = "y";
      VIDEO_MEDIATEK_VPU = "y";
      VIDEO_MEDIATEK_MDP3 = "y";
      DRM_MEDIATEK = "y";
      DRM_MEDIATEK_DP = "y";
      DRM_MEDIATEK_HDMI = "y";
      ARM_MEDIATEK_CCI_DEVFREQ = "y";
      PWM_MEDIATEK = "y";
    };
    #ignoreConfigErrors = true;

    kernelPatches = [
      {
        name = "mt8183-bt";
        patch = builtins.readFile ./mt8183-fix-bluetooth.patch;
      }
      {
        name = "mt8195-adsp";
        patch = builtins.readFile ./mt8195-adsp.patch;
      }
      {
        name = "mt8195-tomato-nvme";
        patch = builtins.readFile ./mt8195-cherry-tomato-NVMe.patch;
      }
      {
        name = "mt8195-dvfsrc";
        patch = builtins.readFile ./mt8195-dvfsrc.patch;
      }
    ];

    # CI: limit to aarch64-linux
    meta.platforms = [
      "aarch64-linux"
    ];
  };

in
linuxPackagesFor kernel
