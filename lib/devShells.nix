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
  qtDev = mkShell {
    name = "qt-dev";
    buildInputs = [
      cmake
      clang-tools
      gdb
      (
        with qt6;
        env "qt-custom-${qtbase.version}" [
          qmake
          qtdeclarative
          qttools
        ]
      )
      libglvnd
    ];
  };
}
// lib.optionalAttrs (stdenv.isLinux) rec {
  kernelDev = mkShell {
    name = "embedded-dev";
    buildInputs = [
      # Tools
      clang-tools
      depthcharge-tools
      dtc
      go
      lz4
      ubootTools
      u-root
      # menuconfig/nconfig
      pkg-config
      ncurses
      # Additional dependencies
      gnutls
      libusb1
      libftdi1
      python3Packages.libfdt
      # Cross compilers
      coreboot-toolchain.arm
      coreboot-toolchain.aarch64
      coreboot-toolchain.i386
      coreboot-toolchain.x64
      coreboot-toolchain.riscv
      pkgsCross.aarch64-multiplatform.stdenv.cc
      pkgsCross.riscv64.stdenv.cc
      pkgsCross.gnu64.stdenv.cc
      # HOSTCC
      (lib.hiPrio gcc)
    ]
    ++ linux.nativeBuildInputs;
    shellHook = ''
      echo "# Available cross toolchains:"
      echo "  - 'arm-eabi-'"
      echo "  - 'aarch64-elf-'"
      echo "  - 'riscv64-elf-'"
      echo "  - 'i386-elf-'"
      echo "  - 'x86_64-elf-'"
      echo "  - 'aarch64-unknown-linux-gnu-'"
      echo "  - 'riscv64-unknown-linux-gnu-'"
      echo "  - 'x86_64-unknown-linux-gnu-'"
    '';
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
      gcc
      imagemagick
      libuuid
      python3
    ];
    shellHook = ''
      unset STRIP
    '';
  };
  # Alias
  embedded = kernelDev;
}
