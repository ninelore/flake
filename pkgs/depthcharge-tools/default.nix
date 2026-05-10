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
  vboot-utils,
  xz,
  zstd,
  ...
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "depthcharge-tools";
  version = "0.6.4";
  src = fetchgit {
    url = "https://gitlab.postmarketos.org/postmarketOS/depthcharge-tools.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-McnBtc0UpatKO4XBnMOHf2L8xxcrsRM/5DCbmAmfA1o=";
  };

  nativeBuildInputs = [ makeWrapper ];

  pyproject = true;
  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    importlib-metadata
    packaging
  ];

  propagatedBuildInputs = [
    bzip2
    dtc
    gzip
    lz4
    lzop
    ubootTools
    vboot-utils
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
})
