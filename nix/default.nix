{ pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        # Rebuilds mutter, gnome-shell, gnome-control-center
        mutter = prev.mutter.overrideAttrs (oldAttrs: {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            #rev = "triple-buffering-v4-47";
            rev = "17fcf9df5e39b287a65a487790ea5a4d468ee3a4";
            sha256 = "sha256-ajxm+EDgLYeqPBPCrgmwP+FxXab1D7y8WKDQdR95wLI=";
          };
          preConfigure =
            let
              gvdb = final.fetchFromGitLab {
                domain = "gitlab.gnome.org";
                owner = "GNOME";
                repo = "gvdb";
                rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
                hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
              };
            in
            ''
              cp -a "${gvdb}" ./subprojects/gvdb
            '';
        });
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
