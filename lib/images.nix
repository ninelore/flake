{ inputs, ... }:
let
  common =
    {
      pkgs,
      lib,
      modulesPath,
      ...
    }:
    {
      system.stateVersion = "25.05";
      nix = {
        package = pkgs.nixVersions.latest;
        settings = {
          experimental-features = "nix-command flakes";
          auto-optimise-store = true;
          trusted-users = [
            "root"
            "@wheel"
          ];
          substituters = [
            "https://nix-community.cachix.org/"
            "https://cache.nixos.org/"
            "https://9lore.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "9lore.cachix.org-1:H2/a1Wlm7VJRfJNNvFbxtLQPYswP3KzXwSI5ROgzGII="
          ];
        };
      };
      imports = [
        inputs.self.nixosModules.default
        inputs.nix-index-database.nixosModules.nix-index
        # some default installer ISO config
        "${toString modulesPath}/profiles/installation-device.nix"
        "${toString modulesPath}/profiles/base.nix"
      ];
      networking.networkmanager.enable = true;
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "yes";
        };
      };
      networking.wireless.enable = lib.mkImageMediaOverride false;
      boot.supportedFilesystems.zfs = lib.mkForce false;
      boot.kernelParams = [
        "iomem=relaxed"
      ];
      hardware.enableRedistributableFirmware = true;
      programs.nix-index-database.comma.enable = true;
      programs.flashprog.enable = true;
      programs.flashrom.enable = true;
      environment.systemPackages =
        with pkgs;
        [
          # Distro install tools
          apk-tools
          debootstrap
          dnf5
          # Tools
          git
          lm_sensors
          neovim
          ranger
          # Neovim deps
          curl
          gcc
          git
          gnutar
          ripgrep
          tree-sitter
          nil
          nixd
          nixfmt
          # ChromeOS Utilities
          vboot_reference
        ]
        ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
          # FIXME: broken on aarch64 as of 2025-12-29
          coreboot-utils
          # Distro install tools
          arch-install-scripts
        ];
      services.getty.helpLine = lib.mkForce ''
        The "nixos" and "root" accounts have empty passwords.

        To log in over ssh you must set a password for either "nixos" or "root"
        with `passwd` (prefix with `sudo` for "root"), or add your public key to
        /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys.

        If you need a wireless connection, use NetworkManager (nmcli or nmtui).
      '';
    };

  commonGui =
    { pkgs, ... }:
    {
      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.enable = true;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
      environment.systemPackages = with pkgs; [
        ungoogled-chromium
      ];
    };

  specialArgs = { inherit inputs; };

  mkIso = nixosClosure: (inputs.nixpkgs.lib.nixosSystem nixosClosure).config.system.build.images.iso;
in
{
  # Generic x86_64-linux ISO 9660 Image
  iso_gui-x86_64 = mkIso {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      common
      commonGui
      (
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
        }
      )
    ];
  };

  # Generic aarch64-linux ISO 9660 Image
  iso_gui-aarch64 = mkIso {
    inherit specialArgs;
    system = "aarch64-linux";
    modules = [
      common
      commonGui
      (
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
        }
      )
    ];
  };

  # aarch64-linux ISO 9660 Image with linux_cros kernel
  iso_gui_cros-aarch64 = mkIso {
    inherit specialArgs;
    system = "aarch64-linux";
    modules = [
      common
      commonGui
      inputs.self.nixosModules.crosAarch64
      (
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_cros_latest;
          hardware.enableAllHardware = lib.mkForce false;
        }
      )
    ];
  };
}
