{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "alsa-ucm-conf-cros";
  version = 1;

  src = pkgs.fetchFromGitHub {
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
}
