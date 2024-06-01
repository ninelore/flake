{ config, lib, inputs, pkgs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402
    #(nixpkgs + "/installer/scan/not-detected.nix")
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];


  # Formerly /etc/nixos/hardware-configuration.nix

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/9c50dbd6-3a0b-4b6b-86b0-f326320a27dd";

  fileSystems."/.snapshots" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@.snapshots" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/8C76-9B64";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
