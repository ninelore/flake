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
    if ping -c1 github.com > /dev/null 2>&1; then
      git pull --ff-only --autostash || exit 1
    fi

    if [[ $* == *"u"* ]]; then
      sudo nix-channel --update || exit 1
      sudo nix flake update || exit 1
    fi

    if [[ $* == *"b"* ]]; then
      _c=boot
    fi

    if [[ $* == *"i"* ]]; then
      sudo nixos-rebuild "$_c" --impure --flake "$_p" || exit 1
    else 
      sudo nixos-rebuild "$_c" --flake "$_p" || exit 1
    fi
  '';

  nxgc = pkgs.writeShellScriptBin "nxgc" ''
    _n=7

    if [[ $* =~ "[0-9]+" ]]; then 
      _n=$*
    fi

    sudo nix-collect-garbage --delete-older-than "$_n"d --quiet
    nix-collect-garbage --delete-older-than "$_n"d --quiet
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
