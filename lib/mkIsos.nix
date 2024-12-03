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
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            inputs.chaotic.nixosModules.default
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.home-manager
            ../nix
            (
              {
                pkgs,
                lib,
                ...
              }:
              {
                networking.networkmanager.enable = true;
                networking.wireless.enable = lib.mkImageMediaOverride false;
                environment.systemPackages = with pkgs; [
                  apk-tools
                  apt
                  arch-install-scripts
                  dnf5
                  git
                  gh
                  ranger
                ];
                users.users."nixos".password = "nixos";
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs;
                  };
                  users."nixos" = {
                    imports = [
                      ../hm
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
