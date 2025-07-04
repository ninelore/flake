{ inputs, ... }:
let
  mkNixos =
    systems:
    builtins.listToAttrs (
      map (
        systemConfig:
        let
          sys = if (systemConfig ? channel) then systemConfig.channel else inputs.nixpkgs;
          pkgs = import sys {
            system = systemConfig.architecture;
            config.allowUnfree = true;
          };
        in
        {
          name = systemConfig.hostname;
          value = sys.lib.nixosSystem {
            system = systemConfig.architecture;
            inherit pkgs;
            specialArgs = {
              inherit inputs systemConfig;
            };
            modules = [
              ../nixcfg
              ../nixos
              ../hardware/${systemConfig.hostname}
              inputs.self.nixosModules.default
              inputs.chaotic.nixosModules.default
              inputs.nix-index-database.nixosModules.nix-index
              inputs.home-manager.nixosModules.home-manager
              {
                console.keyMap = if (systemConfig ? keymap) then systemConfig.keymap else "us";
                home-manager = {
                  backupFileExtension = "hmbak";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [ inputs.cosmic-manager.homeManagerModules.cosmic-manager ];
                  extraSpecialArgs = {
                    inherit inputs systemConfig;
                  };
                  users.${systemConfig.username} = {
                    imports = [
                      ../hm/gui
                      {
                        nix.channels = {
                          nixpkgs = sys.lib.mkDefault sys;
                        };
                      }
                    ];
                  };
                };
              }
            ];
          };
        }
      ) systems
    );
in
mkNixos
