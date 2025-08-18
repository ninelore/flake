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
    ver = "6.12.42";
    hash = "sha256-SARSiinNIDCaC0HDDlrv/DX6Ie4zWPSnBtRYbQA7wfs=";
  };
  stable = makeVer {
    ver = "6.16.1";
    hash = "sha256-6kNJG8es4eQUs7LZV/jPlucEkVUSPwrM55isz42hrLo=";
  };
  # mainline = makeVer {
  #   version = "";
  #   hash = "";
  # };
}
