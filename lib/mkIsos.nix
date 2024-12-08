{ inputs, ... }:
let
  mkFrankenIsos =
    isos:
    builtins.listToAttrs (
      map (isoArch: {
        name = isoArch + "-iso";
        value = inputs.nixpkgs.lib.nixosSystem {
          system = isoArch;
          modules = [
            (
              {
                pkgs,
                lib,
                ...
              }:
              {
                imports = [
                  "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
                  inputs.home-manager.nixosModules.home-manager
                  ../nix
                ];
                networking.networkmanager.enable = true;
                networking.wireless.enable = lib.mkImageMediaOverride false;
                boot.kernelParams = [
                  "iomem=relaxed"
                ];
                programs = {
                  flashrom = {
                    enable = true;
                    package = pkgs.flashprog;
                  };
                  nix-ld.enable = true;
                };
                environment.systemPackages = with pkgs; [
                  btop
                  coreboot-utils
                  cros-ectool
                  curl
                  dmidecode
                  git
                  less
                  nixfmt-rfc-style
                  pciutils
                  picocom
                  vboot_reference
                  usbutils
                  # Package managers
                  apk-tools
                  apt
                  arch-install-scripts
                  dnf5
                  pacman
                ];
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs;
                  };
                  users."nixos" = {
                    home.stateVersion = "24.05";
                    imports = [
                      ../hm/sh.nix
                      ../hm/helix.nix
                    ];
                  };
                };
              }
            )
          ];
        };
      }) isos
    );
in
mkFrankenIsos
