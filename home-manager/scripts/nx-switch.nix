{pkgs, ...}: let
  nx-switch = pkgs.writeShellScriptBin "nx-switch" ''
    ${
      if pkgs.stdenv.isDarwin
      then "darwin-rebuild switch --flake . --impure"
      else "sudo nixos-rebuild switch --flake . --impure"
    }
  '';
in {
  home.packages = [nx-switch];
}
