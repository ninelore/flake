{ inputs, ... }:
let
  commonModules = [
    inputs.self.nixosModules.default
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
        hardware.enableAllHardware = true;
        hardware.enableRedistributableFirmware = true;
        programs.flashprog.enable = true;
        environment.systemPackages =
          with pkgs;
          [
            # Distro install tools
            apk-tools
            dnf5
            pmbootstrap
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
          ]
          ++ lib.optionals (system == "x86_64-linux") [
            # Distro install tools
            apt
            arch-install-scripts
          ];
      }
    )
  ];
  customFormats = import ./imageFormats;
  specialArgs = { inherit inputs; };
in
{
  # Raw image for MTK-based Chromebooks with Depthcharge
  raw-mt81 = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "aarch64-linux";
    modules = commonModules ++ [
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_mt81;
          boot.kernelParams = [ "console=tty0" ];
        }
      )
    ];
    format = "raw-cros";
  };
  # Raw image for Qualcomm-based Chromebooks with Depthcharge
  raw-sc7180 = inputs.nixos-generators.nixosGenerate {
    inherit customFormats specialArgs;
    system = "aarch64-linux";
    modules = commonModules ++ [
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_sc7180;
          boot.kernelParams = [ "console=tty0" ];
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
          boot.kernelParams = [ "console=tty0" ];
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
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
        }
      )
    ];
    format = "install-iso";
  };
}
