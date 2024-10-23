{ inputs, ... }:
let
  mkNixos =
    systems:
    builtins.listToAttrs (
      map (systemConfig: {
        name = systemConfig.hostname;
        value = inputs.nixpkgs.lib.nixosSystem {
          system = systemConfig.architecture;
          specialArgs = {
            inherit inputs systemConfig;
          };
          modules = [
            ../nix
            ../sys
            ../hardware/${systemConfig.hostname}
            inputs.chaotic.nixosModules.default
            inputs.nix-index-database.darwinModules.nix-index
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs systemConfig;
                };
                users.${systemConfig.username} = {
                  imports = [
                    ../hm
                    ../hm/9l
                    ../hm/gui
                  ];
                };
              };
            }
          ];
        };
      }) systems
    );
in
mkNixos
