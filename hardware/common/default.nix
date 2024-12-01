{ pkgs, ... }:
{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
