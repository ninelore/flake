{ pkgs, ... }:
pkgs.alsa-ucm-conf.overrideAttrs {
  src = pkgs.fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "f7be751655e4298851615bded7adaf364ccfb8c3";
    hash = "sha256-x4DQoYIF8tRlNQ1/vKgTtgzach/CCNYzsl+gxviSVHs=";
  };

  patches = [];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/alsa
    cp -r ucm2 $out/share/alsa/
    runHook postInstall
  '';
}
