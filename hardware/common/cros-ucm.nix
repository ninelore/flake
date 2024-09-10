{ pkgs, ... }:
let
  cros-ucm =
    with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        owner = "WeirdTreeThing";
        repo = "alsa-ucm-conf-cros";
        rev = "f7be751655e4298851615bded7adaf364ccfb8c3";
        hash = "sha256-x4DQoYIF8tRlNQ1/vKgTtgzach/CCNYzsl+gxviSVHs=";
      };

      postInstall = ''
        cp -rf $wttsrc/ucm2/* $out/share/alsa/
      '';
    };
in
{
  #system.replaceRuntimeDependencies = with pkgs; [
  #  {
  #    original = alsa-ucm-conf;
  #    replacement = cros-ucm;
  #  }
  #];

  environment = {
    sessionVariables.ALSA_CONFIG_UCM2 = "${cros-ucm}/share/alsa/ucm2";
    systemPackages = [ pkgs.sof-firmware ];
  };
}
