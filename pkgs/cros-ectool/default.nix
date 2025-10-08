{
  cmake,
  fetchFromGitHub,
  libftdi1,
  libusb1,
  pkg-config,
  stdenv,
  lib,
  ...
}:
stdenv.mkDerivation {
  pname = "cros-ectool";
  version = "0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "DHowett";
    repo = "ectool";
    rev = "0ac6155abbb7d4622d3bcf2cdf026dde2f80dad7";
    hash = "sha256-EMOliuyWB0xyrYB+E9axZtJawnIVIAM5nx026tESi38=";
  };

  nativeBuildInputs = [
    libftdi1
  ];

  buildInputs = [
    cmake
    libftdi1
    libusb1
    pkg-config
  ];

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.10" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/ectool $out/bin/ectool

    runHook postInstall
  '';

  meta = {
    description = "chromium embedded controller tool";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
