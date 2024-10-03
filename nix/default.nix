{ inputs, pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        # nixos-unstable-small
        pkgs-small = import inputs.nixpkgs-small {
          system = final.system;
          config.allowUnfree = true;
        };
        # Aarch64 fd
        aarch64fd = inputs.nixpkgs.legacyPackages."aarch64-linux".OVMF.fd;
        # Fix file collision
        visualvm = prev.visualvm.overrideAttrs {
          fixupPhase = ''
            mv $out/LICENSE.txt $out/visualvm-LICENSE.txt
          '';
        };
      })
      # Custom packages
      (final: prev: import ../pkgs { pkgs = prev.pkgs; })
      # VSCode Extensions
      inputs.vscode-ext.overlays.default
    ];
  };
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [ "https://devenv.cachix.org" ];
      trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
