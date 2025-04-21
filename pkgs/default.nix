{ inputs, system, ... }:
with import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
};
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
  warcraftlogs = callPackage ./warcraftlogs-uploader { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  linux_mt81 = callPackage ./linux_mt81 { };
  linux_sc7180 = callPackage ./linux_sc7180 { };
}
