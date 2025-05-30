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

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_cros;
  boot.kernelParams = [
    "plymouth.enable=0"
    "loglevel=15"
  ];
  boot.consoleLogLevel = lib.mkForce 15;

  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/05fba921-a014-489a-918d-6627c136ef5c";
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
    device = "/dev/disk/by-uuid/FA92-685C";
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
