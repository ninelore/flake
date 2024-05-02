{ pkgs, ... }:
let
  nxsw = pkgs.writeShellScriptBin "nxsw" ''
    _p=.
    if [[ -r $HOME/.nx-flakepath ]]; then
      if [[ -r "$(cat "$HOME"/.nx-flakepath)/flake.nix" ]]; then
        _p=$(cat "$HOME"/.nx-flakepath)
        echo "Found flakepath $_p"
        cd "$_p" || exit 1
      fi
    fi

    if [[ $1 == "-u" ]]; then
      sudo nix-channel --update
      sudo nix flake update
    fi
    sudo nixos-rebuild switch --flake "$_p" --impure
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
in
{
  home.packages = [ nxsw nx-flakepath-update ];
}
