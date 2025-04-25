{ lib, pkgs, ... }:
{
  # Custom kernels are missing "required" default modules (legacy hardware).
  # Lets write our own defaults
  boot.initrd.includeDefaultModules = lib.mkForce false;
  hardware.enableAllHardware = lib.mkForce false;
  boot.initrd.availableKernelModules = [
    # Storage
    "nvme"
    "mmc_block"
  ];
  boot.initrd.kernelModules = [
    "dm_mod"
  ];
}
