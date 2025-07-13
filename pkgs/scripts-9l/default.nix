{
  lib,
  buildEnv,
  home-manager,
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
  hm = writeNuBin "hm" (withPkgs [ home-manager ]) (builtins.readFile ./hm.nu);
  nxr = writeNuBin "nxr" (builtins.readFile ./nxr.nu);
  spawnb = writeShellScriptBin "spawnb" ''
    nohup $* &
  '';
in
buildEnv {
  name = "9l-scripts";
  paths = [
    flakepath-update
    hm
    nxr
    spawnb
  ];
}
