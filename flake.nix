##################################
##                              ##
##    ninelore's nixos config   ##
##                              ##
##################################

{
  description = "9l.nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-alien.url = "github:thiagokokada/nix-alien";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar.url = "github:Alexays/Waybar";

    #matugen.url = "github:InioX/matugen";
  };

  outputs =
    inputs @ { home-manager
    , nixpkgs
    , ...
    }: {
      # nixos config
      nixosConfigurations = {
        "9l-zephyr" =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./9l.nix
              ./hardware/9l-zephyr.nix
              ./nixos-pc/nixos.nix
              home-manager.nixosModules.home-manager
            ];
          };
        "9l-lillipup" =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./9l.nix
              ./hardware/9l-lillipup.nix
              ./nixos-pc/nixos.nix
              home-manager.nixosModules.home-manager
            ];
          };
      };
    };
}
