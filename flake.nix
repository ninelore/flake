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
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-github-actions = {
      url = "github:ninelore/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chrultrabook-tools = {
      url = "github:death7654/chrultrabook-tools/c79cc0bd1744838ddcf36fa45e72efecbed707fd"; # v3.0.2 + flake stuff
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      configs = import ./9l { inherit inputs; };
    in
    inputs.flake-utils.lib.eachDefaultSystem (system: {
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      packages = import ./pkgs { inherit inputs system; };
      devShells = with inputs.nixpkgs.legacyPackages.${system}; {
        default = mkShellNoCC {
          packages = [
            nil
            nixd
            nixfmt-rfc-style
          ];
        };
      };
    })
    // {
      githubActions = inputs.nix-github-actions.lib.mkGithubMatrix { checks = self.packages; };
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
          import = path: path; # let the module system know what we are exporting
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
        };
      homeModules.default = {
        nixpkgs.overlays = [ self.overlays.default ];
        nix.settings = {
          substituters = [ "https://9lore.cachix.org" ];
          trusted-public-keys = [ "9lore.cachix.org-1:H2/a1Wlm7VJRfJNNvFbxtLQPYswP3KzXwSI5ROgzGII=" ];
        };
      };
    };
}
