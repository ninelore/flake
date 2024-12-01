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

  # Generated from here
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "dwc3_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/385f5c5f-ed66-4f01-bcb3-6c47ecf959b0";
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9427-7F30";
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
