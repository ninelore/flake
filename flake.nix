#    ___  __            _                              _____     __
#   / _ \/ /__  _______( )___    __ _  ___  ___  ___  / _/ /__ _/ /_____
#   \_, / / _ \/ __/ -_)/(_-<   /  ' \/ _ \/ _ \/ _ \/ _/ / _ `/  '_/ -_)
#  /___/_/\___/_/  \__/ /___/  /_/_/_/\___/_//_/\___/_//_/\_,_/_/\_\\__/
#
{
  description = "9lore's monoflake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    #nixos-stable.url = "ngithub:nixos/nixpkgs/nixos-24.11"; # Unused
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
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      configs = import ./9l { inherit inputs; };
    in
    inputs.flake-utils.lib.eachSystem supportedSystems (system: {
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      legacyPackages = import ./pkgs { inherit inputs system; };
      devShells = import ./lib/devShells.nix { pkgs = inputs.nixpkgs.legacyPackages.${system}; };
    })
    // {
      lib = import ./lib;
      githubActions = self.lib.mkGithubMatrix {
        sourceAttrSet = self.legacyPackages;
        attrPrefix = "legacyPackages";
        lib = inputs.nixpkgs.lib;
      };
      nixosImages = import ./lib/images.nix { inherit inputs; };
      nixosConfigurations = configs.nixos;
      homeConfigurations = configs.hm;
      overlays.default =
        final: prev:
        import ./pkgs {
          inherit inputs;
          system = prev.system;
        };
      nixosModules =
        let
          import = path: path;
        in
        {
          default = {
            nixpkgs.overlays = [ self.overlays.default ];
            nix.settings = {
              substituters = [ "https://9lore.cachix.org" ];
              trusted-public-keys = [ "9lore.cachix.org-1:H2/a1Wlm7VJRfJNNvFbxtLQPYswP3KzXwSI5ROgzGII=" ];
            };
          };
          cros = import ./modules/cros;
          crosSetuid = import ./modules/cros/setuid;
          crosAarch64 = import ./modules/cros/aarch64;
        };
      homeModules.default = {
        nixpkgs.overlays = [ self.overlays.default ];
        nix.settings = {
          extra-substituters = [ "https://9lore.cachix.org" ];
          extra-trusted-public-keys = [ "9lore.cachix.org-1:H2/a1Wlm7VJRfJNNvFbxtLQPYswP3KzXwSI5ROgzGII=" ];
        };
      };
    };
}
