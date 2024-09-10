{ pkgs, ... }:
{
  #system.replaceRuntimeDependencies = with pkgs; [
  #  {
  #    original = alsa-ucm-conf;
  #    replacement = pkgs.alsa-ucm-conf-cros;
  #  }
  #];

  environment = {
    sessionVariables.ALSA_CONFIG_UCM2 = "${pkgs.alsa-ucm-conf-cros}/share/alsa/ucm2";
    systemPackages = [ pkgs.sof-firmware ];
  };
}
