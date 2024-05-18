{ pkgs, ... }:
let
  eshare = pkgs.stdenv.mkDerivation
    {

      name = "eshare-bin";
      src = pkgs.fetchurl {
        url = "https://cdn.sharemax.cn/rel/linux/EShareClient_v7.5.0220_amd64.deb";
        sha256 = "b276effb6d5ffa6d54c5f9cbffa037e92926e8a413205f5b2d07eaae3632f5b1";
      };

      buildInputs = with pkgs; [
        libglvnd
        pango
        elfutils # for libdw.so.1
        libunwind
        libdrm
        alsa-lib
        libgpg-error
        e2fsprogs # for libcom_err.so.2
      ];

      dontUnpack = true;
      dontBuild = true;
      dontStrip = true;

      nativeBuildInputs = with pkgs; [
        dpkg
        autoPatchelfHook
      ];


      installPhase = ''
        runHook preInstall

        mkdir -p $out
        dpkg --fsys-tarfile $src | tar --extract
        mv opt $out/

        mkdir -p $out/share/applications
        cp $out/opt/EShare/EShare.desktop $out/share/applications
      
        # fix the path in the desktop file
        substituteInPlace \
          $out/share/applications/EShare.desktop \
          --replace /opt/ $out/opt/
      
        mkdir -p $out/bin 
      
        # symlink the binary to bin/
        ln -s $out/opt/EShare/EShare $out/bin/Eshare

        runHook postInstall
      '';

    };
in
{
  home.packages = [ eshare ];
}
