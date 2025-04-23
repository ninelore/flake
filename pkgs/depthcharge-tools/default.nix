{
  bzip2,
  dtc,
  fetchgit,
  gzip,
  lib,
  lz4,
  lzop,
  makeWrapper,
  python3Packages,
  ubootTools,
  vboot_reference,
  xz,
  zstd,
  ...
}:
with python3Packages;
buildPythonApplication rec {
  name = "depthcharge-tools";
  version = "0.6.2";
  src = fetchgit {
    url = "https://github.com/alpernebbi/depthcharge-tools";
    hash = "sha256-3xPRNDUXLOwYy8quMfYSiBfzQl4peauTloqtZBGbvlw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    bzip2
    dtc
    gzip
    lz4
    lzop
    setuptools
    ubootTools
    vboot_reference
    xz
    zstd
  ];

  meta = {
    description = "Tools to manage the Chrome OS bootloader ";
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

}
