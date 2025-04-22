{ inputs, ... }:
{
  mkHm = import ./mkHm.nix { inherit inputs; };
  mkNixos = import ./mkNixos.nix { inherit inputs; };
}
