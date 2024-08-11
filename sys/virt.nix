{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
      };
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
  };
}
