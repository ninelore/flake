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

    hyprland.url = "github:hyprwm/Hyprland/v0.40.0";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    waybar.url = "github:Alexays/Waybar";

    #matugen.url = "github:InioX/matugen";
  };

  outputs =
    inputs @ { self
    , home-manager
    , nixpkgs
    , ...
    }: {
      # nixos config
      nixosConfigurations = {
        "${nixpkgs.lib.strings.fileContents "/etc/nixos/HOSTNAME"}" =
          let
            hostname = nixpkgs.lib.strings.fileContents /etc/nixos/HOSTNAME;
            username = "9l";
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = { inherit inputs; };
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
                    "podman"
                    "adbusers"
                    "plugdev"
                    "openrazer"
                  ];
                };
                environment.variables = {
                  HOSTNAME = hostname;
                };
                networking.hostName = hostname;
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs; };
                  users.${username} = {
                    home.username = username;
                    home.homeDirectory = "/home/${username}";
                    imports = [ ./home-manager/home.nix ];
                  };
                };
              }
            ];
          };
      };
    };
}
