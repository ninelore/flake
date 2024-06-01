##################################
##                              ##
##    ninelore's nixos config   ##
##                              ##
##################################

{
  description = "9l.nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
              ./hardware/ga402r.nix
              ./nixos-pc/nixos.nix
              home-manager.nixosModules.home-manager
              { networking.hostName = "9l-zephyr"; }
            ];
          };
      };
    };
}
