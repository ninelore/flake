{ inputs, ... }:
let
  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
  forSystemsPkgs =
    f:
    inputs.nixpkgs.lib.genAttrs supportedSystems (
      system:
      f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      }
    );
in
{
  inherit forSystems forSystemsPkgs;
  mkNixos = import ./mkNixos.nix { inherit inputs; };
  mkIsos = import ./mkIsos.nix { inherit inputs; };
}
