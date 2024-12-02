##################################
##                              ##
##     ninelore's monoflake     ##
##                              ##
##################################

{
  description = "9lore's monoflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixos-stable.url = "ngithub:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

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
    inputs@{ self, ... }:
    let
      myLib = import ./lib { inherit inputs; };
    in
    {

      nixosConfigurations =
        # nixos pc configs
        myLib.mkNixos [
          {
            username = "9l";
            hostname = "9l-zephyr";
            architecture = "x86_64-linux";
          }
          {
            username = "9l";
            hostname = "9l-eldrid";
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

      packages = myLib.forSystems (system: (import ./pkgs inputs.nixpkgs.legacyPackages.${system}));

      devShells = myLib.forSystemsPkgs (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt-rfc-style
              statix
              vulnix
            ];
          };
        }
      );

      formatter = myLib.forSystemsPkgs (pkgs: pkgs.nixfmt-rfc-style);

    };
}
