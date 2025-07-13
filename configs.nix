{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) mergeAttrsList;
  inherit (inputs.self.lib) mkSystem mkHm;

  configs = {
    nixos = mergeAttrsList [
      (mkSystem {
        inherit inputs;
        defaultUser = "9l";
        hostName = "9l-zephyr";
        swapfile = 16 * 1024;
        extraModules = [
          {
            ninelore.gaming = true;
            ninelore.vr = true;
          }
        ];
      })
      (mkSystem {
        inherit inputs;
        defaultUser = "9l";
        hostName = "9l-drobit";
        swapfile = 32 * 1024;
        extraModules = [
          {
            ninelore.gaming = true;
          }
        ];
      })
      (mkSystem {
        inherit inputs;
        defaultUser = "9l";
        hostName = "9l-drobit";
        system = "aarch64-linux";
      })
    ];
    hm = mergeAttrsList [ ];
  };
in
configs
