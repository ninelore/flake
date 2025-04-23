{
  "raw-cros" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/NIXOS";
          autoResize = true;
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/disk/by-label/ESP";
          fsType = "vfat";
        };
      };
      boot = {
        growPartition = true;
        kernelParams = [
          "console=tty0"
          "iomem=relaxed"
        ];
        loader.systemd-boot = {
          enable = true;
        };
        supportedFilesystems.zfs = lib.mkForce false;
      };

      hardware = {
        enableAllHardware = true;
        enableRedistributableFirmware = true;
      };

      system.build.raw = import ./make-disk-image.nix {
        inherit lib config pkgs;
        inherit (config.virtualisation) diskSize;
      };
      formatAttr = "raw";
      fileExtension = ".img";
    };
}
