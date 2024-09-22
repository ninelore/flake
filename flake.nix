##################################
##                              ##
##     ninelore's nix config    ##
##                              ##
##################################

{
  description = "9lore's Nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-ext = {
      url = "github:nix-community/nix-vscode-extensions";
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
    let
      architectures = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forSystems = nixpkgs.lib.genAttrs architectures;

      mkSystems =
        systems:
        builtins.listToAttrs (
          map (systemConfig: {
            name = systemConfig.hostname;
            value = nixpkgs.lib.nixosSystem {
              system = systemConfig.architecture;
              specialArgs = {
                inherit inputs systemConfig;
              };
              modules = [
                ./nix
                ./sys
                ./hardware/${systemConfig.hostname}
                chaotic.nixosModules.default
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = {
                      inherit inputs systemConfig;
                    };
                    users.${systemConfig.username} = {
                      imports = [
                        ./hm
                        ./hm/9l
                        ./hm/gui
                      ];
                    };
                  };
                }
              ];
            };
          }) systems
        );
      mkFrankenIsos =
        isos:
        builtins.listToAttrs (
          map (isoArch: {
            name = isoArch + "-iso";
            value = nixpkgs.lib.nixosSystem {
              system = isoArch;
              modules = [
                (
                  {
                    pkgs,
                    lib,
                    modulesPath,
                    ...
                  }:
                  {
                    imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
                    networking.networkmanager.enable = true;
                    networking.wireless.enable = lib.mkImageMediaOverride false;
                    nix.package = pkgs.nixVersions.latest;
                    nix.settings.experimental-features = "nix-command flakes";
                    environment.systemPackages = with pkgs; [
                      arch-install-scripts
                      git
                      gh
                      ranger
                    ];
                  }
                )
              ];
            };
          }) isos
        );
    in
    {
      # packages
      packages = forSystems (system: (import ./pkgs nixpkgs.legacyPackages.${system}));

      nixosConfigurations =
        # nixos pc configs
        mkSystems [
          {
            username = "9l";
            hostname = "9l-zephyr";
            architecture = "x86_64-linux";
          }
          {
            username = "9l";
            hostname = "9l-lillipup";
            architecture = "x86_64-linux";
          }
        ]

        # iso images
        # cmd: `nix build .#nixosConfigurations.{arch}-iso.config.system.build.isoImage`
        // mkFrankenIsos [
          "x86_64-linux"
          "aarch64-linux"
        ];
    };
}
