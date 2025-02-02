{ inputs, ... }:
let
  mkNixos =
    systems:
    builtins.listToAttrs (
      map (
        systemConfig:
        let
          sys = if (systemConfig ? channel) then systemConfig.channel else inputs.nixos;
          isGaming = systemConfig ? gaming && systemConfig.gaming;
        in
        {
          name = systemConfig.hostname;
          value = sys.lib.nixosSystem {
            system = systemConfig.architecture;
            specialArgs = {
              inherit inputs systemConfig;
            };
            modules = [
              ../nix
              ../sys
              ../hardware/${systemConfig.hostname}
              inputs.chaotic.nixosModules.default
              inputs.nix-index-database.nixosModules.nix-index
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs systemConfig;
                  };
                  users.${systemConfig.username} = {
                    imports =
                      [
                        ../hm/9l
                        ../hm/gui
                        {
                          nix.channels = {
                            nixpkgs = sys.lib.mkDefault sys;
                          };
                        }
                      ]
                      ++ sys.lib.optionals isGaming [
                        ../hm/gui/gaming.nix
                      ];
                  };
                };
                console.keyMap = if (systemConfig ? keymap) then systemConfig.keymap else "us";
                programs.steam = {
                  enable = isGaming;
                  gamescopeSession.enable = isGaming; # TODO: trial
                };
              }
            ];
          };
        }
      ) systems
    );
in
mkNixos
