{ pkgs, ... }:
with pkgs;
{
  default = mkShellNoCC {
    name = "nix-dev-shell";
    buildInputs = [
      git
      nixd
      nixfmt
    ];
  };
}
// lib.optionalAttrs (stdenv.isLinux) {
  kernelDev = mkShell {
    name = "kernel-dev";
    buildInputs = [
      # Tools
      clang-tools
      dtc
      ubootTools
      lz4
      # Additional Linux dev dependencies
      pkg-config
      ncurses
      # Additional barebox dependencies
      libftdi1
      python3Packages.libfdt
      # Cross compilers
      pkgsCross.aarch64-multiplatform.stdenv.cc
      pkgsCross.gnu64.stdenv.cc
      # HOSTCC
      (lib.hiPrio gcc)
    ]
    ++ linux.nativeBuildInputs;
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
  };
  coreboot = mkShellNoCC {
    name = "coreboot-dev";
    buildInputs = [
      # Utilities
      clang-tools
      coreboot-utils
      dtc
      git
      ubootTools
      # coreboot dependencies
      cacert
      cmocka
      coreboot-toolchain.arm
      coreboot-toolchain.aarch64
      coreboot-toolchain.i386
      coreboot-toolchain.x64
      ncurses
      openssh
      openssl
      pkg-config
      # edk2
      gcc14 # Required by OpensslLib
      imagemagick
      libuuid
      python3
    ];
    shellHook = ''
      unset STRIP
    '';
  };
}
