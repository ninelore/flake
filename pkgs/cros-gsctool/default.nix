{
  fetchgit,
  libftdi,
  libusb,
  openssl,
  pkg-config,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "cros-gsctool";
  version = "0.1.0";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/ec.git";
    branchName = "gsc_utils";
    rev = "7ae912f3575666d682b728875bdbeec3ba27b65f";
    hash = "sha256-40wJQpwTdeO3yXPvnL1Mensqr+nkClVQjaZKxOy7kIk=";
  };

  # TODO
  nativeBuildInputs = [
    libftdi
  ];

  buildInputs = [
    libftdi
    libusb
    openssl
    pkg-config
  ];

  buildPhase = ''
    cd extra/usb_updater
    make
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp extra/usb_updater $out/bin/gsctool
    runHook postInstall
  '';
}
