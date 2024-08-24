{ pkgs, ... }:
{
  services.ollama = {
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1032"; # RX 6700S
      #HCC_AMDGPU_TARGET = "gfx1035"; # RX 680M
    };
    rocmOverrideGfx = "10.3.2"; # adjust to above
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
  ];
}
