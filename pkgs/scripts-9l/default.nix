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
  fucking-realtek = writeShellScriptBin "fucking_realtek" ''
    sudo rmmod r8153_ecm r8152
    sudo modprobe r8152
    sudo modprobe r8153_ecm
  '';

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
    fucking-realtek
  ];
}
