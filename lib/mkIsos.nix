{ inputs, ... }:
let
  mkFrankenIsos =
    isos:
    builtins.listToAttrs (
      map (isoArch: {
        name = isoArch + "-iso";
        value = inputs.nixpkgs.lib.nixosSystem {
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
                imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix") ];
                networking.networkmanager.enable = true;
                networking.wireless.enable = lib.mkImageMediaOverride false;
                nix.package = pkgs.nixVersions.latest;
                nix.settings.experimental-features = "nix-command flakes";
                environment.systemPackages = with pkgs; [
                  apk-tools
                  apt
                  arch-install-scripts
                  dnf5
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
mkFrankenIsos
