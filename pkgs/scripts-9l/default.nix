{
  lib,
  buildEnv,
  nh,
  writers,
  writeShellScriptBin,
  ...
}:
let
  # Helpers
  inherit (writers) writeNuBin;
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
  spawnb = writeShellScriptBin "spawnb" ''
    nohup $* &
  '';
  nx = writeNuBin "nx" (withPkgs [ nh ]) (builtins.readFile ./nx.nu);

  # Deprecated!
  nxr = writeNuBin "nxr" (builtins.readFile ./nxr.nu);
in
buildEnv {
  name = "9l-scripts";
  paths = [
    flakepath-update
    nx
    nxr
    spawnb
  ];
}
