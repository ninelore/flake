{ pkgs }:
let
  version = "7.5.0509";
in
pkgs.stdenv.mkDerivation {
  name = "eshare-bin";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://cdn.sharemax.cn/rel/linux/EShareClient_v${version}_amd64.deb";
    sha256 = "sha256-4Vx5UXti4ukK/ITEBD/17CNUJRyo5xm4APBAYL+iXRE=";

    #url = "https://update.digitale-tafel.com/sharing/ubuntu-app/ubuntu.zip";
    #sha256 = "e715fd6aa9642a47f0b925f03da15f15ceb456f5950f0576a1d38710bdc20f60";
  };

  buildInputs = with pkgs; [
    fontconfig
    xorg.libX11
    libgcc
    glib
    libglvnd
    pango
    alsa-lib
    libunwind
    elfutils
    libgpg-error
    e2fsprogs
    libdrm
  ];

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    dpkg
    unzip
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
}
