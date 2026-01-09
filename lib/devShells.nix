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
  kernelBuild = mkShell {
    name = "kernel-build";
    buildInputs = [
      # Tools
      clang-tools
      coreboot-utils
      dtc
      ubootTools
      # Linux deps
      ncurses
      pkg-config
      # musl?
      lld
    ]
    ++ linux.nativeBuildInputs;
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
  };
  kernelBuildClang = mkShell.override { stdenv = llvmPackages.stdenv; } {
    name = "kernel-build";
    buildInputs = [
      ncurses
      pkg-config
      # musl?
      lld
    ];
    inputsFrom = [ (linux.override { stdenv = llvmPackages.stdenv; }) ];
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
    AR = "${llvmPackages.bintools-unwrapped}/bin/ar";
    NM = "${llvmPackages.bintools-unwrapped}/bin/nm";
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
      coreboot-toolchain.riscv
      ncurses
      openssh
      openssl
      pkg-config
      # edk2
      gcc14
      imagemagick
      libuuid
      python3
    ];
    shellHook = ''
      unset STRIP
    '';
  };
}
// lib.optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
  crossArm64 = mkShell {
    name = "generic-cross-arm64";
    buildInputs = [
      # Tools
      clang-tools
      coreboot-utils
      dtc
      ubootTools
      # gs101 needs Image.lz4
      lz4
      # Linux deps
      ncurses
      pkg-config
      # musl?
      lld
      # Compiler
      pkgsCross.aarch64-multiplatform.stdenv.cc
      pkgsCross.aarch64-multiplatform-musl.stdenv.cc
      (lib.hiPrio gcc)
    ]
    ++ linux.nativeBuildInputs;
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
    # CROSS_COMPILE = "aarch64-unknown-linux-gnu-";
    CROSS_COMPILE = "aarch64-unknown-linux-musl-";
    ARCH = "arm64";
  };

}
