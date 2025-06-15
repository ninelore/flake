{ pkgs, ... }:
let
  # TODO: Standalone HM
  nxr = pkgs.writeShellScriptBin "nxr" ''
    _p=.
    if [[ -r $HOME/.nx-flakepath ]] && ! [[ -r ./flake.nix ]]; then
      if [[ -r "$(cat "$HOME"/.nx-flakepath)/flake.nix" ]]; then
        _p=$(cat "$HOME"/.nx-flakepath)
        cd "$_p" || exit 1
        echo "Found flakepath $_p"
      fi
    fi
    if ping -c1 github.com > /dev/null 2>&1; then
      git pull --ff-only --autostash || exit 1
    fi
    run0 nixos-rebuild --flake $_p $*
  '';

  hm = pkgs.writeShellScriptBin "hm" ''
    _p=.
    if [[ -r $HOME/.nx-flakepath ]] && ! [[ -r ./flake.nix ]]; then
      if [[ -r "$(cat "$HOME"/.nx-flakepath)/flake.nix" ]]; then
        _p=$(cat "$HOME"/.nx-flakepath)
        cd "$_p" || exit 1
        echo "Found flakepath $_p"
      fi
    fi
    if ping -c1 github.com > /dev/null 2>&1; then
      git pull --ff-only --autostash || exit 1
    fi
    ${pkgs.home-manager}/bin/home-manager $_p $*
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
    hm
    nxr
    nx-flakepath-update
    spawnb
  ];
}
