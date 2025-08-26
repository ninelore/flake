{
  cosmic-comp,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
cosmic-comp.overrideAttrs (oldAttrs: rec {
  version = "1.0.0-alpha.7-unstable-2025-08-26";
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "2ccdb6c93d50a727fc8b00f3010b417048dbbffa";
    hash = "sha256-hj5gYpLdZWkRH0tvgZMgJBMNIteZ/tg/WKvTxKLpltw=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-wGq7Cdq56Hnzww+IVXCtZet4Zojj8VUmmsjsg53XHe8=";
  };
})
