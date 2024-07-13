{ pkgs, inputs, ... }:
let
  # FIXME: Temp workaround
  rocmllvmsmall = final: prev: {
    rocmPackages = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.rocmPackages;
  };
in
{
  # TODO: Move stuff here thats not home-manager and required on non-NixOS setups
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ rocmllvmsmall ];
  };
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
}
