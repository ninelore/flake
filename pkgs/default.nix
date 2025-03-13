{ inputs, system, ... }:
with inputs.nixpkgs.legacyPackages.${system};
let
  crosKernel = callPackage ./linuxPackages_cros { };
in
{
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  chrultrabook-tools = inputs.chrultrabook-tools.packages.${system}.default.overrideAttrs {
    meta.platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
  cros-ectool = callPackage ./cros-ectool { };
  #cros-gsctool = callPackage ./cros-gsctool { }; # Broken
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  linux_cros = crosKernel.kernel;
  linuxPackages_cros = crosKernel;
}
