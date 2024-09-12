{
  cmake,
  fetchgit,
  libftdi1,
  libusb,
  pkg-config,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "cros-ectool";
  version = "0.1.0";

  src = fetchgit {
    url = "https://gitlab.howett.net/DHowett/ectool.git";
    rev = "0ac6155abbb7d4622d3bcf2cdf026dde2f80dad7";
    hash = "sha256-XfDE+P9BxTvTCeuZjnjCmS1CN7hz79WM5MaHq/Smpq0=";
  };

  # TODO
  nativeBuildInputs = [
    libftdi1
  ];

  buildInputs = [
    cmake
    libftdi1
    libusb
    pkg-config
  ];

  buildPhase = ''
    cmake .
    make
  '';

  # Rename to crosectool due to conflict with coreboot-utils
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/ectool $out/bin/crosectool

    runHook postInstall
  '';
}
