{ pkgs, ... }:
with pkgs;
alsa-ucm-conf.overrideAttrs {
  wttsrc = fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "f7be751655e4298851615bded7adaf364ccfb8c3";
    hash = "sha256-x4DQoYIF8tRlNQ1/vKgTtgzach/CCNYzsl+gxviSVHs=";
  };

  postInstall = ''
    cp -rf $wttsrc/ucm2 $out/share/alsa/
  '';
}
