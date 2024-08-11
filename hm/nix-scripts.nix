{ pkgs, ... }:
let
  nxsw = pkgs.writeShellScriptBin "nxsw" ''
    _p=.
    _c=switch

    if [[ -r $HOME/.nx-flakepath ]]; then
      if [[ -r "$(cat "$HOME"/.nx-flakepath)/flake.nix" ]]; then
        _p=$(cat "$HOME"/.nx-flakepath)
        echo "Found flakepath $_p"
        cd "$_p" || exit 1
      fi
    fi

    # Do not abort when theres just no internet
    if ping -c1 github.coam > /dev/null 2>&1; then
      git pull --ff-only --autostash || exit 1
    fi

    if [[ $* == *"u"* ]]; then
      sudo nix-channel --update || exit 1
      sudo nix flake update || exit 1
    fi

    if [[ $* == *"b"* ]]; then
      _c=boot
    fi

    sudo nixos-rebuild "$_c" --flake "$_p" || exit 1
  '';

  nxgc = pkgs.writeShellScriptBin "nxgc" ''
    sudo nix-collect-garbage --delete-older-than 7d --quiet
    nix-collect-garbage --delete-older-than 7d --quiet
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
    nxsw
    nxgc
    nx-flakepath-update
    spawnb
  ];
}
