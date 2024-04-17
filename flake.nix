################################
##                            ##
##    ninelore's nix config   ##
##                            ##
################################

{
  description = "9l.nix";

  inputs = {
    dotfiles.url = "github:ninelore/dots";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    #matugen.url = "github:InioX/matugen";
  };

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    ...
  }: {
    # nixos config
    nixosConfigurations = {
      "nixos" = let
        username = "9l";
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/nixos.nix
            home-manager.nixosModules.home-manager
            {
              users.users.${username} = {
                isNormalUser = true;
                initialPassword = username;
                extraGroups = [
                  "networkmanager"
                  "power"
                  "wheel"
                  "audio"
                  "video"
                  "libvirtd"
                  "docker"
                  "adbusers"
                  "plugdev"
                  "openrazer"
                ];
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs;};
                users.${username} = {
                  home.username = username;
                  home.homeDirectory = "/home/${username}";
                  imports = [./nixos/home.nix];
                };
              };
            }
          ];
        };
    };
  };
}