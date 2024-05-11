{ config, inputs, pkgs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402
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
}
