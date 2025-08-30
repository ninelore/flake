{ inputs, system, ... }:
with import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
};
{
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  chrultrabook-tools = callPackage "${inputs.chrultrabook-tools}" { };
  cosmic-manager = callPackage "${inputs.cosmic-manager}/cosmic-manager" { }; # For caching
  cros-ectool = callPackage ./cros-ectool { };
  #cros-gsctool = callPackage ./cros-gsctool { }; # Broken
  depthcharge-tools = callPackage ./depthcharge-tools { };
  ghidra-server = callPackage ./ghidra-server { };
  #iosevka-9l = callPackage ./iosevka-9l { }; # Broken
  kdeconnect-kde_git = callPackage ./kdeconnect-kde-git { };
  linux_cros = callPackage ./linux_cros { };
  linux_cros_latest = callPackage ./linux_cros_latest { };
  #linux_nix_cros = callPackage ./linux_nix_cros { }; # Unfinished
  linux_sc7180_legacy = callPackage ./linux_sc7180 { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  scripts-9l = callPackage ./scripts-9l { };
  submarine = callPackage ./submarine { };
  warcraftlogs = callPackage ./warcraftlogs-uploader { };

  # Aliases
  linux_mt81 = throw "'linux_mt81' has been refactored to 'linux_cros'";
  linux_sc7180 = throw "'linux_sc7180' has been deprecated in favor of 'linux_cros'. It is available as 'linux_sc7180_legacy'";
}
