{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "warcraftlogs-uploader";
  version = "8.16.19";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v8.16.19/warcraftlogs-v${version}.AppImage";
    hash = "sha256-MUu97EbdYQxtcs1hnv85kjWqWY+G9Dv/8NqcX+3gUIk=";
  };

  meta = {
    description = "Warcraftlogs Uploader";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;
}
