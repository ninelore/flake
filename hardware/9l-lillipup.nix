{ config, lib, modulesPath, ... }:
{
  # Formerly /etc/nixos/hardware-configuration.nix from 9l-lillipup

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./common/volteer.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/db6018c8-faea-4145-bd01-f5145d2307ff";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-c173d741-16c4-47d0-9bf1-a719109ff5e7".device = "/dev/disk/by-uuid/c173d741-16c4-47d0-9bf1-a719109ff5e7";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/67C3-667D";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u1u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
