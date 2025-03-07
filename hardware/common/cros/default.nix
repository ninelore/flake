{ pkgs, ... }:
{
  # TODO: wireplumber headroom
  environment = {
    sessionVariables.ALSA_CONFIG_UCM2 = "${pkgs.alsa-ucm-conf-cros}/share/alsa/ucm2";
    systemPackages = with pkgs; [
      sof-firmware
    ];
    # TODO: No handling for Nocturne, Atlas, Eve, Sarien and Arcada keyboards yet
    etc = {
      "libinput/cros.quirks".text = ''
        [keyd virtual keyboard]
        MatchName=keyd virtual keyboard
        AttrKeyboardIntegration=internal
        ModelTabletModeNoSuspend=1
      '';
    };
  };
  boot = {
    kernelParams = [ "iomem=relaxed" ];
    initrd.systemd.tpm2.enable = false;
  };
  hardware.sensor.iio.enable = true;
  security = {
    tpm2.enable = false;
    wrappers = {
      cbmem = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.cbmem}/bin/cbmem";
      };
      ectool = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.cros-ectool}/bin/ectool";
      };
    };
  };
  systemd.services."getty@tty11" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };
  services = {
    keyd.enable = true;
    libinput.enable = true;
  };
}
