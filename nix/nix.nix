{ ... }:
{
  # TODO: Move stuff here thats not home-manager and required on non-NixOS setups
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ ];
  };
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
}
