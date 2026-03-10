{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "archon-app";
  version = "9.0.1";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-archon/releases/download/v${version}/archon-v${version}.AppImage";
    hash = "sha256-chKKBeQPDMsnFUyR3CysttlTXZdMUbhNkUJq/dyJdNY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    ;

  extraInstallCommands = ''
    ls ${appimageContents}
    install -m 444 -D "${appimageContents}/Archon App.desktop" $out/share/applications/archonapp.desktop
    install -m 444 -D "${appimageContents}/usr/share/icons/hicolor/512x512/apps/Archon App.png" \
      "$out/share/icons/hicolor/512x512/apps/Archon App.png"
    substituteInPlace $out/share/applications/archonapp.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Archon app";
    homepage = "https://www.archon.gg/download";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };

}
