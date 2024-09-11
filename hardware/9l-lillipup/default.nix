# Formerly /etc/nixos/hardware-configuration.nix from 9l-lillipup
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common/volteer.nix
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # From nixos-generate-config onwards
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/357c342a-7680-47c1-9402-daace1cb31cc";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/a37f130a-fe47-47ea-a808-f0b89291d72e";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6324-84EE";
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
