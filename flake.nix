##################################
##                              ##
##     ninelore's monoflake     ##
##                              ##
##################################

{
  description = "9lore's Monoflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs-gnomeExt.url = "github:nixos/nixpkgs/e2f176cf4a4f2badcc5bb1b226f87f2fd011d100";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{ ... }:
    let
      myLib = import ./lib { inherit inputs; };
    in
    {
      # packages
      packages = myLib.forSystems (system: (import ./pkgs inputs.nixpkgs.legacyPackages.${system}));

      nixosConfigurations =
        # nixos pc configs
        myLib.mkNixos [
          {
            username = "9l";
            hostname = "9l-zephyr";
            architecture = "x86_64-linux";
            bleeding = true;
          }
          {
            username = "9l";
            hostname = "9l-lillipup";
            architecture = "x86_64-linux";
          }
        ]
        // myLib.mkIsos [
          "x86_64-linux"
          "aarch64-linux"
        ];

      homeConfigurations = {
        "ninel" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = myLib.forSystems (system: (import inputs.nixpkgs { system = system; }));
          modules = [
            ./nix
            ./hm
            ./hm/gui
            ./hm/9l
            {
              targets.genericLinux.enable = true;
            }
          ];
        };
      };
    };
}
