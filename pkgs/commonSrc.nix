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
    ver = "6.16.5";
    hash = "sha256-dr/7rn6rKh3h7QVpK+9wn0OwKlL+la5lXKzw+iUiE/M=";
  };
  # mainline = makeVer {
  #   version = "";
  #   hash = "";
  # };
}
