{ pkgs, ... }:
with pkgs;
alsa-ucm-conf.overrideAttrs {
  wttsrc = fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "00b399ed00930bfe544a34358547ab20652d71e3";
    hash = "sha256-lRrgZDb3nnZ6/UcIsfjqAAbbSMOkP3lBGoGzZci+c1k=";
  };

  postInstall = ''
    cp -rf $wttsrc/ucm2 $out/share/alsa/
  '';
}
