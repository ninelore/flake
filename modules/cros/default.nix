{
  lib,
  pkgs,
  ...
}:
{
  # TODO: wireplumber headroom
  boot.initrd.systemd.tpm2.enable = lib.mkDefault false;
  boot.kernelParams = [ "iomem=relaxed" ];
  environment = {
    sessionVariables.ALSA_CONFIG_UCM2 = lib.mkDefault "${pkgs.alsa-ucm-conf-cros}/share/alsa/ucm2";
    systemPackages = with pkgs; [
      sof-firmware
    ];
    etc = {
      "libinput/cros.quirks".text = lib.mkDefault ''
        [keyd virtual keyboard]
        MatchName=keyd virtual keyboard
        AttrKeyboardIntegration=internal
        ModelTabletModeNoSuspend=1
      '';
    };
  };
  hardware.sensor.iio.enable = lib.mkDefault true;
  services = {
    keyd.enable = lib.mkDefault true;
    libinput.enable = lib.mkDefault true;
  };
  security.tpm2.enable = lib.mkDefault false;
}
