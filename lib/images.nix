{ inputs, ... }:
let
  commonModules = [
    inputs.self.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
    ../9l/nixcfg
    (
      {
        pkgs,
        lib,
        modulesPath,
        ...
      }:
      {
        system.stateVersion = "24.11";
        imports = [
          # some default installer ISO config
          "${toString modulesPath}/profiles/installation-device.nix"
          "${toString modulesPath}/profiles/base.nix"
        ];
        networking.networkmanager.enable = true;
        networking.wireless.enable = lib.mkImageMediaOverride false;
        boot.supportedFilesystems.zfs = lib.mkForce false;
        boot.kernelParams = [
          "iomem=relaxed"
        ];
        hardware.enableRedistributableFirmware = true;
        programs.nix-index-database.comma.enable = true;
        programs.flashprog.enable = true;
        environment.systemPackages =
          with pkgs;
          [
            # Distro install tools
            apk-tools
            dnf5
            # Tools
            git
            neovim
            ranger
            # Neovim deps
            fd
            gcc
            git
            gnumake
            lua5_1
            luarocks
            ripgrep
            tree-sitter
            wget
            nil
            nixd
            nixfmt-rfc-style
            # ChromeOS Utilities
            vboot_reference
            submarine
          ]
          ++ lib.optionals (system == "x86_64-linux") [
            # Distro install tools
            apt
            arch-install-scripts
          ];
        services.getty.helpLine = lib.mkForce ''
          The "nixos" and "root" accounts have empty passwords.

          To log in over ssh you must set a password for either "nixos" or "root"
          with `passwd` (prefix with `sudo` for "root"), or add your public key to
          /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys.

          If you need a wireless connection, use NetworkManager (nmcli or nmtui).
        '';
      }
    )
  ];

  customFormats = import ./imageFormats { inherit inputs; };
  specialArgs = { inherit inputs; };
in
{
  # Raw image for MTK-based Chromebooks with Depthcharge
  raw-aarch64cros = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "aarch64-linux";
    modules = commonModules ++ [
      inputs.self.nixosModules.crosAarch64
      (
        { pkgs, ... }:
        {
          boot.kernelParams = [ "console=tty0" ];
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_cros;
        }
      )
    ];
    format = "raw-cros";
  };
  # Raw image for Intel or AMD-based Chromebooks with Depthcharge
  raw-x64cros = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "x86_64-linux";
    modules = commonModules ++ [
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
        }
      )
    ];
    format = "raw-cros";
  };
  # ISO 9660 image for reqular x86_64 computers
  iso-x86_64 = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "x86_64-linux";
    modules = commonModules ++ [
      (
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
          image.baseName = lib.mkForce "nixos-${pkgs.system}-${inputs.self.shortRev or "dirty"}";
        }
      )
    ];
    format = "install-iso";
  };
}
