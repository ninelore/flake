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

  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
  ];

  services.ollama = {
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1032"; # RX 6700S
      #HCC_AMDGPU_TARGET = "gfx1035"; # RX 680M
    };
    rocmOverrideGfx = "10.3.2"; # adjust to above
  };

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
  ];

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
