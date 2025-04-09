{ inputs, ... }:
let
  mkNixos =
    systems:
    builtins.listToAttrs (
      map (
        systemConfig:
        let
          sys = if (systemConfig ? channel) then systemConfig.channel else inputs.nixpkgs;
          extras = systemConfig ? extras && systemConfig.extras;
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
              ../sys
              ../hardware/${systemConfig.hostname}
              inputs.self.nixosModules.default
              inputs.chaotic.nixosModules.default
              inputs.nix-index-database.nixosModules.nix-index
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "hmbak";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                  extraSpecialArgs = {
                    inherit inputs systemConfig;
                  };
                  users.${systemConfig.username} = {
                    imports =
                      [
                        ../hm/gui
                        {
                          nix.channels = {
                            nixpkgs = sys.lib.mkDefault sys;
                          };
                        }
                      ]
                      ++ sys.lib.optionals extras [
                        ../hm/gui/extra
                      ];
                  };
                };
                console.keyMap = if (systemConfig ? keymap) then systemConfig.keymap else "us";
                programs.steam = {
                  enable = extras;
                  gamescopeSession.enable = extras; # TODO: trial
                };
              }
            ];
          };
        }
      ) systems
    );
in
mkNixos
