{ inputs, system, ... }:
with import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
};
rec {
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  chrultrabook-tools = inputs.chrultrabook-tools.packages.${system}.default;
  cosmic-clipboard-manager = callPackage ./cosmic-clipboard-manager { };
  cosmic-manager = inputs.cosmic-manager.packages.${system}.default; # For caching
  cros-ectool = callPackage ./cros-ectool { };
  #cros-gsctool = callPackage ./cros-gsctool { }; # Broken
  depthcharge-tools = callPackage ./depthcharge-tools { };
  ghostty = inputs.ghostty.packages.${system}.ghostty; # For caching
  #iosevka-9l = callPackage ./iosevka-9l { }; # Broken
  kdeconnect-kde_git = callPackage ./kdeconnect-kde-git { };
  linux_cros = callPackage ./linux_cros { };
  linux_cros_latest = callPackage ./linux_cros_latest { };
  #linux_nix_cros = callPackage ./linux_nix_cros { }; # Unfinished
  linux_sc7180_legacy = callPackage ./linux_sc7180 { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  submarine = callPackage ./submarine { };
  warcraftlogs = callPackage ./warcraftlogs-uploader { };

  # Aliases
  linux_mt81 = throw "'linux_mt81' has been refactored to 'linux_cros'";
  linux_sc7180 = throw "'linux_sc7180' has been deprecated in favor of 'linux_cros'. It is available as 'linux_sc7180_legacy'";
}
