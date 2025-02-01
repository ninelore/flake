# Partially formerly /etc/nixos/hardware-configuration.nix from 9l-zephyr
{
  config,
  lib,
  inputs,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common
    ../common/asus
  ];

  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "sdhci_pci"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/9c50dbd6-3a0b-4b6b-86b0-f326320a27dd";
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
    device = "/dev/disk/by-uuid/D547-AF4A";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
