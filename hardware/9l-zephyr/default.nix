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
    ./asus.nix
    ../common/gaming.nix
    ../common/virt-x86.nix
  ];

  #boot.kernelPackages = pkgs.linuxPackages_cachyos;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    aarch64fd
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
    rocm-opencl-icd
    rocm-opencl-runtime
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

  # From nixos-generate-config onwards
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/9c50dbd6-3a0b-4b6b-86b0-f326320a27dd";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
    fsType = "btrfs";
    options = [ "subvol=@.snapshots" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8C76-9B64";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
