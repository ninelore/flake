{ inputs, ... }:
let
  modules = {
    isoBase =
      {
        lib,
        modulesPath,
        ...
      }:
      {
        imports = [
          "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
          "${toString modulesPath}/installer/cd-dvd/latest-kernel.nix"
        ];
        isoImage.edition = "graphical";
        isoImage.showConfiguration = lib.mkDefault false;
        specialisation = {
          gnome.configuration =
            { config, ... }:
            {
              imports = [
                "${toString modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
              ];
              isoImage.showConfiguration = true;
              isoImage.configurationName = "GNOME (Linux ${config.boot.kernelPackages.kernel.version})";
            };

          plasma.configuration =
            { config, ... }:
            {
              imports = [
                "${toString modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
              ];
              isoImage.showConfiguration = true;
              isoImage.configurationName = "Plasma (Linux ${config.boot.kernelPackages.kernel.version})";
            };
        };
      };

    common =
      {
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.self.nixosModules.default
          inputs.nix-index-database.nixosModules.nix-index
        ];
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
            curl
            gcc
            git
            lm_sensors
            neovim
            ranger
            ripgrep
            tree-sitter
            # ChromeOS Utilities
            vboot_reference
          ]
          ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
            # Still broken on aarch64
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
  };

  specialArgs = { inherit inputs; };

  mkIso = nixosClosure: (inputs.nixpkgs.lib.nixosSystem nixosClosure).config.system.build.isoImage;
in
{
  # Generic x86_64-linux ISO 9660 Image
  iso_gui-x86_64 = mkIso {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = with modules; [
      isoBase
      common
    ];
  };

  # Generic aarch64-linux ISO 9660 Image
  iso_gui-aarch64 = mkIso {
    inherit specialArgs;
    system = "aarch64-linux";
    modules = with modules; [
      isoBase
      common
    ];
  };
}
