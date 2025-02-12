{ inputs, ... }:
let
  mkHm =
    systems:
    builtins.listToAttrs (
      map (hmConfig: {
        name = hmConfig.user;
        value = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs { system = hmConfig.arch; };
          modules = [
            ../nix
            (if (hmConfig ? gui) then ../hm/gui else ../hm/cli)
            {
              home.username = hmConfig.user;
              home.homeDirectory = "/home/${hmConfig.user}";
              targets.genericLinux.enable = true;
              nix.channels = {
                nixpkgs = inputs.nixpkgs.lib.mkDefault inputs.nixpkgs;
              };
            }
          ];
        };
      }) systems
    );
in
mkHm
