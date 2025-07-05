{ lib, pkgs, ... }:
let
  # Helpers
  inherit (pkgs) writeShellScriptBin;
  inherit (pkgs.writers) writeNuBin;
  withPkgs = pkgs: {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath pkgs}"
    ];
  };

  # Scripts
  flakepath-update = writeNuBin "flakepath-update" (builtins.readFile ./flakepath-update.nu);
  hm = writeNuBin "hm" (withPkgs [ pkgs.home-manager ]) (builtins.readFile ./hm.nu);
  nxr = writeNuBin "nxr" (builtins.readFile ./nxr.nu);
  spawnb = writeShellScriptBin "spawnb" ''
    nohup $* &
  '';
in
{
  home.packages = [
    flakepath-update
    hm
    nxr
    spawnb
  ];
}
