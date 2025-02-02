##################################
##                              ##
##     ninelore's monoflake     ##
##                              ##
##################################

{
  description = "9lore's monoflake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    #nixos-stable.url = "ngithub:nixos/nixpkgs/nixos-24.11"; # Unused
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      myLib = import ./lib { inherit inputs; };
    in
    {
      nixosConfigurations =
        myLib.mkNixos [
          {
            username = "9l";
            hostname = "9l-zephyr";
            architecture = "x86_64-linux";
            gaming = true;
            keymap = "de";
          }
          {
            username = "9l";
            hostname = "9l-eldrid";
            architecture = "x86_64-linux";
            keymap = "de";
          }
          {
            username = "9l";
            hostname = "9l-drobit";
            architecture = "x86_64-linux";
            keymap = "uk";
          }
        ]
        // myLib.mkIsos [
          "x86_64-linux"
          "aarch64-linux"
        ];
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: {
      devShells =
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              nixfmt-rfc-style
              statix
              vulnix
            ];
          };
        };

      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      homeConfigurations = {
        "ninel" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs { inherit system; };
          modules = [
            ./nix
            ./hm
            ./hm/gui
            ./hm/9l
            {
              targets.genericLinux.enable = true;
              nix.channels = {
                nixpkgs = inputs.nixpkgs.lib.mkDefault inputs.nixpkgs;
              };
            }
          ];
        };
      };

      packages = import ./pkgs inputs.nixos.legacyPackages.${system};
    });
}
