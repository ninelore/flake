{ inputs, system, ... }:
with import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
};
{
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  cros-ectool = callPackage ./cros-ectool { };
  #cros-gsctool = callPackage ./cros-gsctool { }; # Broken
  depthcharge-tools = callPackage ./depthcharge-tools { };
  # fiedka = callPackage ./fiedka { }; # WIP
  # ghidra-server = callPackage ./ghidra-server { }; # Broken
  #iosevka-9l = callPackage ./iosevka-9l { }; # Broken
  linux_9l_testing = callPackage ./linux_9l_test { };
  linux_cros_latest = callPackage ./linux_cros_latest { };
  #linux_nix_cros = callPackage ./linux_nix_cros { }; # Unfinished
  linux_sc7180_legacy = callPackage ./linux_sc7180 { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  scripts-9l = callPackage ./scripts-9l { };
  submarine = callPackage ./submarine { };
  warcraftlogs = callPackage ./warcraftlogs-uploader { };

  # Aliases
  chrultrabook-tools = throw "chrultrabook-tools has been removed in favor of the upstream flake";
  linux_mt81 = throw "'linux_mt81' has been removed in favor of 'linux_cros_latest'";
  linux_cros = throw "'linux_cros' has been removed in favor of 'linux_cros_latest'";
  linux_sc7180 = throw "'linux_sc7180' has been deprecated in favor of 'linux_cros'. It is available as 'linux_sc7180_legacy'";
}
