{
  cosmic-comp,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
cosmic-comp.overrideAttrs (oldAttrs: rec {
  version = "1.0.0-alpha.7-unstable-2025-06-26";
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "17d6edb6d521563f21b3ed1d6911f1a073a71808";
    hash = "sha256-9Et7yBlR3vjRHqIRhOjrNOiBb5rLlxx97UQ2qv4WUTw=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-H2u6gg45LR9PeWPFL8MFemrurSCFiH1lqV5DOWTUSyk=";
  };
})
