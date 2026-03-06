{ inputs, ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      import ./../../pkgs {
        inherit inputs;
        system = prev.stdenv.hostPlatform.system;
      }
    )
  ];
  nix = {
    registry = {
      ninelore = {
        from = {
          id = "ninelore";
          type = "indirect";
        };
        to = {
          type = "github";
          owner = "ninelore";
          repo = "flake";
        };
      };
    };
    settings = {
      extra-substituters = [ "https://9lore.cachix.org" ];
      extra-trusted-public-keys = [ "9lore.cachix.org-1:H2/a1Wlm7VJRfJNNvFbxtLQPYswP3KzXwSI5ROgzGII=" ];
    };
  };
}
