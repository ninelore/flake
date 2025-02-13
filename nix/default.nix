{ pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        # Workaround https://github.com/NixOS/nixpkgs/issues/380196
        lldb = prev.lldb.overrideAttrs {
          dontCheckForBrokenSymlinks = true;
        };
      })
      # Custom packages
      (final: prev: import ../pkgs { pkgs = prev.pkgs; })
    ];
  };
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      #substituters = [ ];
      #trusted-public-keys = [ ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
