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
          nixfmt-rfc-style
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

  customFormats = import ./imageFormats { inherit inputs; };
  specialArgs = { inherit inputs; };
in
{
  # Raw image for MTK-based Chromebooks with Depthcharge
  raw-aarch64cros = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "aarch64-linux";
    modules = [
      common
      inputs.self.nixosModules.crosAarch64
      (
        { pkgs, ... }:
        {
          boot.kernelParams = [ "console=tty0" ];
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_cros_latest;
        }
      )
    ];
    format = "raw-cros";
  };

  # Raw image for Intel or AMD-based Chromebooks with Depthcharge
  raw-x64cros = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "x86_64-linux";
    modules = [
      common
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
        }
      )
    ];
    format = "raw-cros";
  };

  # Generic x86_64-linux ISO 9660 Image
  iso_gui-x86_64 = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "x86_64-linux";
    modules = [
      common
      commonGui
      (
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
          image.baseName = lib.mkForce "nixos-${pkgs.stdenv.hostPlatform.system}-${
            inputs.self.shortRev or "dirty"
          }";
        }
      )
    ];
    format = "install-iso";
  };

  # Generic aarch64-linux ISO 9660 Image
  iso_gui-aarch64 = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "aarch64-linux";
    modules = [
      common
      commonGui
      (
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
          image.baseName = lib.mkForce "nixos-${pkgs.stdenv.hostPlatform.system}-${
            inputs.self.shortRev or "dirty"
          }";
        }
      )
    ];
    format = "install-iso";
  };

  # aarch64-linux ISO 9660 Image with linux_cros kernel
  iso_gui_cros-aarch64 = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "aarch64-linux";
    modules = [
      common
      commonGui
      (
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_cros_latest;
          image.baseName = lib.mkForce "nixos-cros-${pkgs.stdenv.hostPlatform.system}-${
            inputs.self.shortRev or "dirty"
          }";
        }
      )
    ];
    format = "install-iso";
  };
}
