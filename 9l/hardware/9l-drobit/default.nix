{
  config,
  inputs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    "${inputs.nixos-hardware}/common/cpu/intel/tiger-lake"
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common
    ../common/cros
  ];

  boot.kernelParams = [
    "initcall_blacklist=simpledrm_platform_driver_init"
  ];

  boot.initrd.availableKernelModules = [
    "thunderbolt"
    "nvme"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/052f554d-1f74-4800-816c-1d0fbd807b4a";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7D36-428A";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
