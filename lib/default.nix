{ inputs, ... }:
{
  mkNixos = import ./mkNixos.nix { inherit inputs; };
  mkIsos = import ./mkIsos.nix { inherit inputs; };

  forSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
