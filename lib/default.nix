{ inputs, ... }:
{
  mkNixos = import ./mkNixos.nix { inherit inputs; };
  mkIsos = import ./mkIsos.nix { inherit inputs; };
}
