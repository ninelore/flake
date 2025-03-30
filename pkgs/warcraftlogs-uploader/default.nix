{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "warcraftlogs";
  version = "8.16.25";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v${version}/warcraftlogs-v${version}.AppImage";
    hash = "sha256-/HHxJgdL5Opwa2ZPZxl7DmVXWbuPzqrvYINapKMKmaI=";
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
    install -m 444 -D ${appimageContents}/warcraftlogs.desktop $out/share/applications/warcraftlogs.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/warcraftlogs.png \
      $out/share/icons/hicolor/512x512/apps/warcraftlogs.png
    substituteInPlace $out/share/applications/warcraftlogs.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Warcraftlogs Uploader";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };

}
