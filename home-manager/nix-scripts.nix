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

    git pull || exit 1

    if [[ $1 == "-u" ]]; then
      sudo nix-channel --update || exit 1
      sudo nix flake update || exit 1
      git add flake.lock || exit 1
      git commit -m "update flake"
    fi
    sudo nixos-rebuild switch --flake "$_p" || exit 1
  '';

  nxgc = pkgs.writeShellScriptBin "nxgc" ''
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d
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
  home.packages = [ nxsw nxgc nx-flakepath-update ];
}
