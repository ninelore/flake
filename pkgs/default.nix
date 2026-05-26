{ inputs, system, ... }:
with import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
};
let
  quassel_git = kdePackages.callPackage ./quassel-git { };
in
{
  adwaita-kvantum = callPackage ./adwaita-kvantum { };
  alsa-ucm-conf-cros = callPackage ./alsa-ucm-conf-cros { };
  cros-ectool = callPackage ./cros-ectool { };
  # cros-gsctool = callPackage ./cros-gsctool { }; # Broken
  # fiedka = callPackage ./fiedka { }; # WIP
  # ghidra-server = callPackage ./ghidra-server { }; # Broken
  linux_cros_latest = callPackage ./linux_cros_latest { };
  plymouth-bgrt-luks = callPackage ./plymouth-bgrt-luks { };
  scripts-9l = callPackage ./scripts-9l { };
  submarine = callPackage ./submarine { };

  inherit quassel_git;
  quasselClient_git = quassel_git.override {
    monolithic = false;
    client = true;
    tag = "-client-qt6";
  };
  quasselDaemon_git = quassel_git.override {
    monolithic = false;
    enableDaemon = true;
    tag = "-daemon-qt6";
  };

  # Aliases
  chrultrabook-tools = throw "chrultrabook-tools has been removed in favor of the upstream flake";
  linux_mt81 = throw "'linux_mt81' has been removed in favor of 'linux_cros_latest'";
  linux_cros = throw "'linux_cros' has been removed in favor of 'linux_cros_latest'";
  linux_sc7180 = throw "'linux_sc7180' has been removed in favor of 'linux_latest'";
  linux_sc7180_legacy = throw "'linux_sc7180_legacy' has been removed in favor of 'linux_latest'";
  warcraftlogs = throw "'warcraftlogs' has been removed";
  archon-app = throw "'archon-app' has been removed";
}
