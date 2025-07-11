{ pkgs, ... }:
{
  services = {
    monado = {
      enable = true;
      defaultRuntime = true;
    };
    udev.packages = with pkgs; [ xr-hardware ];
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
    # XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT = "1";
    # AMD_VULKAN_ICD = "RADV";
  };
}
