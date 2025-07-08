{ pkgs, ... }:
with pkgs;
{
  default = mkShellNoCC {
    packages = [
      nixd
      nixfmt-rfc-style
    ];
  };
}
// lib.optionalAttrs (stdenv.isLinux) {
  kernelBuild = mkShell {
    name = "kernel-build";
    nativeBuildInputs = [
      ncurses
      pkg-config
    ] ++ pkgs.linux.nativeBuildInputs;
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
  };
}
// lib.optionalAttrs (system == "x86_64-linux") {
  coreboot = mkShell {
    name = "coreboot-dev";
    packages = [
      cacert
      gdb
      git
      qemu
      # edk2
      python3
    ];
    buildInputs = [
      ncurses
      openssl
    ];
    nativeBuildInputs = [
      coreboot-toolchain.arm
      coreboot-toolchain.aarch64
      coreboot-toolchain.i386
      pkg-config
      openssh
      # u-boot
      bison
      flex
      # edk2
      libuuid
      imagemagick
      gnat14
    ];
    shellHook = ''
      		unset STRIP
      	'';
  };
  crossArm64 = mkShell {
    name = "generic-cross-arm64";
    nativeBuildInputs = [
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
      (hiPrio gcc)
    ] ++ pkgs.linux.nativeBuildInputs;
    PKG_CONFIG_PATH = "${ncurses}/lib/pkgconfig";
    CROSS_COMPILE = "aarch64-unknown-linux-gnu-";
    ARCH = "arm64";
  };

}
