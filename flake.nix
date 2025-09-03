#    ___  __            _                              _____     __
#   / _ \/ /__  _______( )___    __ _  ___  ___  ___  / _/ /__ _/ /_____
#   \_, / / _ \/ __/ -_)/(_-<   /  ' \/ _ \/ _ \/ _ \/ _/ / _ `/  '_/ -_)
#  /___/_/\___/_/  \__/ /___/  /_/_/_/\___/_//_/\___/_//_/\_,_/_/\_\\__/
#
{
  description = "9lore's monoflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      forSystems = inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      devShells = forSystems (
        system: import ./lib/devShells.nix { pkgs = import inputs.nixpkgs { inherit system; }; }
      );

      formatter = forSystems (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      githubActions = self.lib.mkGithubMatrix {
        sourceAttrSet = self.legacyPackages;
        attrPrefix = "legacyPackages";
        lib = inputs.nixpkgs.lib;
      };

      homeModules = {
        default = import ./modules/default;
      };

      legacyPackages = forSystems (system: import ./pkgs { inherit inputs system; });

      lib = import ./lib;

      nixosImages = import ./lib/images.nix { inherit inputs; };

      nixosModules = {
        default = import ./modules/default;
        cros = import ./modules/cros;
        crosSetuid = import ./modules/cros/setuid;
        crosAarch64 = import ./modules/cros/aarch64;
      };

      overlays.default =
        final: prev:
        import ./pkgs {
          inherit inputs;
          system = prev.system;
        };
    };
}
