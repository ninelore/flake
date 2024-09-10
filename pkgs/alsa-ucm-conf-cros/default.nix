{ pkgs, ... }:
with pkgs;
alsa-ucm-conf.overrideAttrs {
  wttsrc = fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "f7be751655e4298851615bded7adaf364ccfb8c3";
    hash = "sha256-x4DQoYIF8tRlNQ1/vKgTtgzach/CCNYzsl+gxviSVHs=";
  };

  patches = [ ];

  unpackPhase = ''
    runHook preUnpack
    tar xf "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/alsa
    cp -r alsa-ucm*/ucm2 $out/share/alsa
    runHook postInstall
  '';
}
