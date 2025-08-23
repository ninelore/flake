{ pkgs, ... }:
with pkgs;
{
  default = mkShellNoCC {
    name = "nix-dev-shell";
    buildInputs = [
      git
      nixd
      nixfmt-rfc-style
    ];
  };
}
// lib.optionalAttrs (stdenv.isLinux) {
  kernelBuild = mkShell {
    name = "kernel-build";
    buildInputs = [
      ncurses
      pkg-config
      # For u-root initfs
      go
      mkuimage
      u-root
    ]
    ++ linux.nativeBuildInputs;
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
  };
  kernelBuildClang = mkShell.override { stdenv = llvmPackages.stdenv; } {
    name = "kernel-build";
    buildInputs = [
      ncurses
      pkg-config
      # For u-root initfs
      go
      mkuimage
      u-root
      # clangStdenv fixup
      (hiPrio llvmPackages.bintools-unwrapped)
      lld
    ];
    inputsFrom = [ (linux.override { stdenv = llvmPackages.stdenv; }) ];
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
    AR = "${llvmPackages.bintools-unwrapped}/bin/ar";
    NM = "${llvmPackages.bintools-unwrapped}/bin/nm";
  };
  coreboot = mkShell {
    name = "coreboot-dev";
    buildInputs = [
      # Utilities
      coreboot-utils
      dtc
      gdb
      git
      ubootTools
      # coreboot dependencies
      cacert
      coreboot-toolchain.arm
      coreboot-toolchain.aarch64
      coreboot-toolchain.i386
      coreboot-toolchain.x64
      ncurses
      openssh
      openssl
      pkg-config
      # edk2
      gnat14
      imagemagick
      libuuid
      python3
    ];
    shellHook = ''
      						unset STRIP
      					'';
  };
}
// lib.optionalAttrs (system == "x86_64-linux") {
  crossArm64 = mkShell {
    name = "generic-cross-arm64";
    buildInputs = [
      bison
      dtc
      dt-schema
      flex
      git
      git-repo
      gnutls
      lld
      lz4
      multipath-tools
      ncurses
      pkg-config
      python312
      python312Packages.gnureadline
      python312Packages.rfc3987
      yamllint
      pkgsCross.aarch64-multiplatform.stdenv.cc
      pkgsCross.aarch64-multiplatform-musl.stdenv.cc
      (hiPrio gcc)
    ]
    ++ linux.nativeBuildInputs;
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
    # CROSS_COMPILE = "aarch64-unknown-linux-gnu-";
    CROSS_COMPILE = "aarch64-unknown-linux-musl-";
    ARCH = "arm64";
  };

}
