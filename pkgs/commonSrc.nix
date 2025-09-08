{ lib, fetchurl, ... }:
let
  makeVer =
    { ver, hash }:
    {
      inherit ver;
      src = fetchurl {
        url = "mirror://kernel/linux/kernel/v${lib.versions.major ver}.x/linux-${ver}.tar.xz";
        inherit hash;
      };
    };
in
{
  lts = makeVer {
    ver = "6.12.45";
    hash = "sha256-j5WoVJz737icEYGh9VqXHwTfzWKVCKLtcLd3q5L52z4=";
  };
  stable = makeVer {
    ver = "6.16.4";
    hash = "sha256-1qXjxxoQtTOnViUTh8yL9Iu9XHbYQrpelX2LHDFqtiI";
  };
  # mainline = makeVer {
  #   version = "";
  #   hash = "";
  # };
}
