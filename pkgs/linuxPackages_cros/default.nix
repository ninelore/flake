{
  linuxPackagesFor,
  linuxKernel,
  ...
}:

let
  kernel = linuxKernel.kernels.linux_6_12.override {
    defconfig = builtins.readFile ./config.aarch64;

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
    kernelArch = "aarch64-linux";
    extraMeta = {
      platforms = [
        "aarch64-linux"
      ];
    };
  };

in
linuxPackagesFor kernel
