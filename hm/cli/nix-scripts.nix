{ pkgs, ... }:
let
  nxr = pkgs.writeShellScriptBin "nxr" ''
    _p=.
    if [[ -r $HOME/.nx-flakepath ]] && ! [[ -r ./flake.nix ]]; then
      if [[ -r "$(cat "$HOME"/.nx-flakepath)/flake.nix" ]]; then
        _p=$(cat "$HOME"/.nx-flakepath)
        echo "Found flakepath $_p"
      fi
    fi
    run0 nixos-rebuild --flake $_p $*
  '';

  nx-flakepath-update = pkgs.writeShellScriptBin "nx-flakepath-update" ''
    echo "checking flake validity..."
    if [[ -r ./flake.nix ]]; then
      pwd > "$HOME"/.nx-flakepath
      echo "success"
    else
      echo "failed"
    fi
  '';

  spawnb = pkgs.writeShellScriptBin "spawnb" ''
    nohup $* &
  '';
in
{
  home.packages = [
    nxr
    nx-flakepath-update
    spawnb
  ];
}
