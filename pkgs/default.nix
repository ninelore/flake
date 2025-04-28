{ inputs, system, ... }:
with import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
};
rec {
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
  depthcharge-tools = callPackage ./depthcharge-tools { };
  #iosevka-9l = callPackage ./iosevka-9l { };
  linux_cros = callPackage ./linux_cros { };
  #linux_nix_cros = callPackage ./linux_nix_cros { };
  linux_sc7180_legacy = callPackage ./linux_sc7180 { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  submarine = callPackage ./submarine { };
  warcraftlogs = callPackage ./warcraftlogs-uploader { };

  # Aliases
  linux_mt81 = throw "'linux_mt81' has been refactored to 'linux_cros'";
  linux_sc7180 = throw "'linux_sc7180' has been deprecated in favor of 'linux_cros'. It is available as 'linux_sc7180_legacy'";
}
