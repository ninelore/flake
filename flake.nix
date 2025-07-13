#    ___  __            _                              _____     __
#   / _ \/ /__  _______( )___    __ _  ___  ___  ___  / _/ /__ _/ /_____
#   \_, / / _ \/ __/ -_)/(_-<   /  ' \/ _ \/ _ \/ _ \/ _/ / _ `/  '_/ -_)
#  /___/_/\___/_/  \__/ /___/  /_/_/_/\___/_//_/\___/_//_/\_,_/_/\_\\__/
#
{
  description = "9lore's monoflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chrultrabook-tools = {
      url = "github:death7654/chrultrabook-tools/da45410da1d3fd77da5b024ecf7cde10e3f79ace"; # v3.0.3
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      configs = import ./configs.nix { inherit inputs; };
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

      homeConfigurations = configs.hm;

      homeModules = {
        default = (import ./modules/default) // {
          nix.channels.nixpkgs = inputs.nixpkgs.lib.mkDefault inputs.nixpkgs;
        };
        ninelore = import ./modules/ninelore-hm;
      };

      legacyPackages = forSystems (system: import ./pkgs { inherit inputs system; });

      lib = import ./lib;

      nixosConfigurations = configs.nixos;

      nixosImages = import ./lib/images.nix { inherit inputs; };

      nixosModules = {
        default = import ./modules/default;
        cros = import ./modules/cros;
        crosSetuid = import ./modules/cros/setuid;
        crosAarch64 = import ./modules/cros/aarch64;
        ninelore = import ./modules/ninelore-nixos;
      };

      overlays.default =
        final: prev:
        import ./pkgs {
          inherit inputs;
          system = prev.system;
        };
    };
}
