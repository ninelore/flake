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
      if [[ $* == *"c"* ]]; then
        nix flake update --commit-lock-file
      else
        nix flake update || exit 1
      fi
    fi

    if [[ $* == *"b"* ]]; then
      _c=boot
    fi

    if [[ $* == *"i"* ]]; then
      run0 nixos-rebuild "$_c" --impure --flake "$_p" || exit 1
    else
      run0 nixos-rebuild "$_c" --flake "$_p" || exit 1
    fi
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

  devflake = pkgs.writeShellScriptBin "devflake" ''
    nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
  '';
in
{
  home.packages = [
    devflake
    nxsw
    nx-flakepath-update
    spawnb
  ];
}
