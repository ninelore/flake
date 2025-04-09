{ lib, pkgs, ... }:
{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  #boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;
  boot.kernelPackages =
    if pkgs.system == "x86_64-linux" then
      lib.mkDefault pkgs.linuxPackages_cachyos
    else
      lib.mkDefault pkgs.linuxPackages_latest;
}
