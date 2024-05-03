{ pkgs, ... }:
let
  eshare = pkgs.stdenv.mkDerivation {
    name = "eshare-bin";
    src = pkgs.fetchurl {
      url = "https://cdn.sharemax.cn/rel/linux/EShareClient_v7.5.0220_amd64.deb";
      sha256 = "b276effb6d5ffa6d54c5f9cbffa037e92926e8a413205f5b2d07eaae3632f5b1";
    };

    buildInputs = with pkgs; [ dpkg bash ];

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      dpkg --fsys-tarfile $src | tar --extract
      mv opt $out/
      mkdir -p $out/share/applications

      runHook postInstall
    '';
  };
in
{
  home.packages = [ eshare ];

  xdg.desktopEntries."EShare" = {
    name = "EShare";
    comment = "EShare";
    icon = "${eshare}/opt/EShare/icon.png";
    exec = "${eshare}/opt/EShare/EShare";
    terminal = false;

  };
}
