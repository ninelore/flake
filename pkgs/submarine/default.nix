{
  bc,
  bison,
  callPackage,
  dtc,
  fetchgit,
  flex,
  elfutils,
  gmp,
  go,
  lib,
  libmpc,
  mpfr,
  openssl,
  parted,
  perl,
  python3,
  stdenv,
  system,
  u-root,
  util-linux,
  vboot_reference,
  ...
}:
let
  arch = {
    "aarch64-linux" = "arm64";
    "x86_64-linux" = "x86_64";
  };
  depthcharge-tools = callPackage ../depthcharge-tools { };
in
stdenv.mkDerivation rec {
  pname = "submarine";
  version = "0.3.0";
  src = fetchgit {
    url = "https://github.com/FyraLabs/submarine";
    rev = "54253a16eeeafed91629544ee081140a4953cde9";
    hash = "sha256-aUFcDQKSUcsIwoLx0qgX2hgUh7UNynhfPyH//su0cHs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    bc
    bison
    depthcharge-tools
    elfutils
    go
    flex
    parted
    perl
    python3
    u-root
    util-linux
    vboot_reference
  ] ++ lib.optionals (system == "aarch64-linux") [ dtc ];
  buildInputs = [
    gmp
    libmpc
    mpfr
    openssl
  ];

  patches = [
    ./0001-Makefile-specify-keys-and-keyblock.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/usr/share/vboot/devkeys/' '${vboot_reference}/share/vboot/devkeys/'
  '';

  preBuild = ''
    export GOCACHE=/tmp/gocache
  '';

  buildPhase = ''
    runHook preBuild
    make -j$NIX_BUILD_CORES ${arch.${system}}
  '';

  installPhase = ''
    mkdir -p $out/share/submarine
    cp -r build/* $out/share/submarine
  '';

  meta = {
    description = "Bootloader for ChromeOS Depthcharge";
    license = lib.licenses.gpl3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
