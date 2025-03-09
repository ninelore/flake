{ inputs, system, ... }:
with inputs.nixpkgs.legacyPackages.${system};
{
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  chrultrabook-tools = inputs.chrultrabook-tools.packages.${system}.default;
  cros-ectool = callPackage ./cros-ectool { };
  #cros-gsctool = callPackage ./cros-gsctool { }; # Broken
}
