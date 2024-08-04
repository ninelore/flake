##################################
##                              ##
##    ninelore's nixos config   ##
##                              ##
##################################

{
  description = "9lore's Nix configurations and profiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-alien.url = "github:thiagokokada/nix-alien";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    ninelore = {
      url = "github:ninelore/9l-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      home-manager,
      nixpkgs,
      chaotic,
      ...
    }:
    {
      # nixos config
      nixosConfigurations = {
        "9l-zephyr" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./9l.nix
            ./hardware/9l-zephyr.nix
            ./nixos/nixos.nix
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
          ];
        };
        "9l-lillipup" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./9l.nix
            ./hardware/9l-lillipup.nix
            ./nixos/nixos.nix
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
          ];
        };
      };
    };
}
