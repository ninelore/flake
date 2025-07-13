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
    inputs.self.nixosModules.cros
    inputs.self.nixosModules.crosSetuid
    inputs.self.nixosModules.crosAarch64
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_cros_latest;
  boot.kernelParams = [
    "loglevel=15"
  ];
  boot.consoleLogLevel = lib.mkForce 15;

  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/5c8a97ac-f27a-429b-9a45-0da1dc1abfc4";
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
    device = "/dev/disk/by-uuid/C7D8-8C1A";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

}
