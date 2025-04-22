{ inputs, ... }:
let
  commonModules = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.chaotic.nixosModules.default
    inputs.self.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
    inputs.home-manager.nixosModules.home-manager
    ../9l/nixcfg
    (
      {
        pkgs,
        lib,
        ...
      }:
      {
        networking.networkmanager.enable = true;
        networking.wireless.enable = lib.mkImageMediaOverride false;
        boot.supportedFilesystems.zfs = lib.mkForce false;
        boot.kernelParams = [
          "iomem=relaxed"
        ];
        hardware.enableAllHardware = true;
        hardware.enableRedistributableFirmware = true;
        programs = {
          command-not-found.enable = false;
          flashrom = {
            enable = true;
            package = pkgs.flashprog;
          };
          nix-index-database.comma.enable = true;
          nix-ld.enable = true;
        };
        environment.systemPackages =
          with pkgs;
          [
            # Distro install tools
            apk-tools
            apt
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
            arch-install-scripts
          ];
      }
    )
  ];
in
{
  raw-mt81 = inputs.nixos-generators.nixosGenerate {
    system = "aarch64-linux";
    format = "raw-efi";
    specialArgs = { inherit inputs; };
    modules = commonModules ++ [
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_mt81;
          boot.kernelParams = [ "console=tty0" ];
        }
      )
    ];
  };
  raw-sc7180 = inputs.nixos-generators.nixosGenerate {
    system = "aarch64-linux";
    format = "raw-efi";
    specialArgs = { inherit inputs; };
    modules = commonModules ++ [
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_sc7180;
          boot.kernelParams = [ "console=tty0" ];
        }
      )
    ];
  };
  iso-x86_64 = inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    format = "install-iso";
    specialArgs = { inherit inputs; };
    modules = commonModules ++ [
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_cachyos;
        }
      )
    ];
  };
}
