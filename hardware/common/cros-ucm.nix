{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      alsa-ucm-conf = prev.alsa-ucm-conf.overrideAttrs {
        wttsrc = pkgs.fetchFromGitHub {
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
      };
    })
  ];

  environment = {
    #sessionVariables.ALSA_CONFIG_UCM2 = "${pkgs.cb-ucm-conf}/share/alsa/ucm2";
    systemPackages = [ pkgs.sof-firmware ];
  };
}