{ inputs, ... }:
let
  mkFrankenIsos =
    isos:
    builtins.listToAttrs (
      map (isoArch: {
        name = isoArch + "-iso";
        value = inputs.nixos.lib.nixosSystem {
          system = isoArch;
          modules = [
            "${inputs.nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            inputs.chaotic.nixosModules.default
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.home-manager
            ../nix
            (
              {
                pkgs,
                lib,
                ...
              }:
              {
                networking.networkmanager.enable = true;
                networking.wireless.enable = lib.mkImageMediaOverride false;
                boot.kernelParams = [
                  "iomem=relaxed"
                ];
                programs = {
                  command-not-found.enable = false;
                  flashrom = {
                    enable = true;
                    package = pkgs.flashprog;
                  };
                  nix-index-database.comma.enable = true;
                  nix-ld.enable = true;
                };
                environment.systemPackages = with pkgs; [
                  # Distro install tools
                  apk-tools
                  apt
                  arch-install-scripts
                  dnf5
                  # Tools
                  git
                  neovim
                  ranger
                  # Neovim deps
                  fd
                  gcc
                  git
                  gnumake
                  lua5_1
                  luarocks
                  ripgrep
                  tree-sitter
                  wget
                  nil
                  nixd
                  nixfmt-rfc-style
                ];
              }
            )
          ];
        };
      }) isos
    );
in
mkFrankenIsos
