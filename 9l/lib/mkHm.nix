{ inputs, ... }:
let
  mkHm =
    systems:
    builtins.listToAttrs (
      map (hmConfig: {
        name = hmConfig.user;
        value = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            system = hmConfig.arch;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs hmConfig; };
          modules = [
            ../nixcfg
            inputs.self.homeModules.default
            inputs.chaotic.homeManagerModules.default
            inputs.nix-index-database.hmModules.nix-index
            (if (hmConfig ? gui) then ../hm/gui else ../hm/cli)
            (
              { pkgs, ... }:
              {
                home.username = hmConfig.user;
                home.homeDirectory = "/home/${hmConfig.user}";
                targets.genericLinux.enable = true;
                nix.channels = {
                  nixpkgs = inputs.nixpkgs.lib.mkDefault inputs.nixpkgs;
                };
                nixGL = {
                  packages = inputs.nixgl.packages;
                  installScripts = [
                    "mesa"
                    "mesaPrime"
                    "nvidiaPrime"
                  ];
                };
                # Experiment: only config
                programs = {
                  kitty.package = if hmConfig ? gui then pkgs.kitty else pkgs.emptyDirectory;
                  nix-index-database.comma.enable = true;
                };
              }
            )
          ];
        };
      }) systems
    );
in
mkHm
