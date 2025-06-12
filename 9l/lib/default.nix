{ inputs, ... }:
{
  mkHm = import ./mkHm.nix { inherit inputs; };
  mkNixos = import ./mkConfig.nix { inherit inputs; };
}
