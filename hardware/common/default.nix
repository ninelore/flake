{ lib, pkgs, ... }:
{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;
}
