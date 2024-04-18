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
        hostname = "nixos";
        username = "9l";
        system = "x86_64-linux";
      in
        nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./nixos/nixos.nix
            home-manager.nixosModules.home-manager
            {
              users.users.${username} = {
                shell = nixpkgs.legacyPackages.${system}.pkgs.nushell;
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
              networking.hostName = hostname;
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