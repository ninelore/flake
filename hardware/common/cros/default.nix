{ pkgs, ... }:
{
  # TODO: wireplumber headroom
  environment = {
    sessionVariables.ALSA_CONFIG_UCM2 = "${pkgs.alsa-ucm-conf-cros}/share/alsa/ucm2";
    systemPackages = with pkgs; [
      sof-firmware
      cros-ectool
    ];
    # TODO: No handling for Nocturne, Atlas, Eve, Sarien and Arcada keyboards yet
    etc = {
      "keyd/cros.conf".text = ''
        ${pkgs.python3.interpreter} ${./cros-keyboard-map.py}      
      '';
      "libinput/cros.quirks".text = ''
        [keyd virtual keyboard]
        MatchName=keyd virtual keyboard
        AttrKeyboardIntegration=internal
        ModelTabletModeNoSuspend=1
      '';
    };
  };

  security.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;

  boot.kernelParams = [ "iomem=relaxed" ];

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
