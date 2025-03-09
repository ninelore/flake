{ inputs, ... }:
{
  mkHm = import ./mkHm.nix { inherit inputs; };
  mkIsos = import ./mkIsos.nix { inherit inputs; };
  mkNixos = import ./mkNixos.nix { inherit inputs; };
}
