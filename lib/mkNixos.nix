{ inputs, ... }:
let
  mkNixos =
    systems:
    builtins.listToAttrs (
      map (
        systemConfig:
        let
          nixpkgs-sys = if (systemConfig ? channel) then systemConfig.channel else inputs.nixpkgs;
        in
        {
          name = systemConfig.hostname;
          value = nixpkgs-sys.lib.nixosSystem {
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
        }
      ) systems
    );
in
mkNixos
