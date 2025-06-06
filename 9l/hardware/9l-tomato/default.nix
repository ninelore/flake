# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.self.nixosModules.crosAarch64
    ../common/cros
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_cros_latest;
  boot.kernelParams = [
    "plymouth.enable=0"
    "loglevel=15"
  ];
  boot.consoleLogLevel = lib.mkForce 15;

  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/8ceac963-e577-4c8f-a1e3-2dc63a1e4d9a";
  };

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7B5D-A4F4";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = lib.mkForce [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
