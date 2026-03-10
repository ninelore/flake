{ inputs, system, ... }:
with import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
};
{
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  archon-app = callPackage ./archon-app { };
  cros-ectool = callPackage ./cros-ectool { };
  #cros-gsctool = callPackage ./cros-gsctool { }; # Broken
  depthcharge-tools = callPackage ./depthcharge-tools { };
  # fiedka = callPackage ./fiedka { }; # WIP
  # ghidra-server = callPackage ./ghidra-server { }; # Broken
  linux_cros_latest = callPackage ./linux_cros_latest { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  scripts-9l = callPackage ./scripts-9l { };
  submarine = callPackage ./submarine { };

  # Aliases
  chrultrabook-tools = throw "chrultrabook-tools has been removed in favor of the upstream flake";
  linux_mt81 = throw "'linux_mt81' has been removed in favor of 'linux_cros_latest'";
  linux_cros = throw "'linux_cros' has been removed in favor of 'linux_cros_latest'";
  linux_sc7180 = throw "'linux_sc7180' has been removed in favor of 'linux_latest'";
  linux_sc7180_legacy = throw "'linux_sc7180_legacy' has been removed in favor of 'linux_latest'";
  warcraftlogs = throw "'warcraftlogs' has been removed in favor of 'archon-app'";
}
