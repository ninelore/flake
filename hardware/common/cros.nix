# Common config for ChromeOS Hardware
{ pkgs, ... }:
let
  cb-ucm-conf = with pkgs; alsa-ucm-conf.overrideAttrs {
    src = fetchFromGitHub {
      owner = "WeirdTreeThing";
      repo = "alsa-ucm-conf-cros";
      rev = "f7be751655e4298851615bded7adaf364ccfb8c3";
      hash = "sha256-x4DQoYIF8tRlNQ1/vKgTtgzach/CCNYzsl+gxviSVHs=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/alsa
      cp -r ucm2 $out/share/alsa/
      runHook postInstall
    '';
  };
in
{
  environment.sessionVariables.ALSA_CONFIG_UCM2 = "${cb-ucm-conf}/share/alsa/ucm2";
  system.replaceRuntimeDependencies = [
    {
      original = pkgs.alsa-ucm-conf;
      replacement = cb-ucm-conf;
    }
  ];
}
