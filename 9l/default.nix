{ inputs, ... }:
let
  myLib = import ./lib { inherit inputs; };
  self = {
    nixos =
      myLib.mkNixos [
        {
          username = "9l";
          hostname = "9l-zephyr";
          architecture = "x86_64-linux";
          extras = true;
          keymap = "de";
        }
        {
          username = "9l";
          hostname = "9l-drobit";
          architecture = "x86_64-linux";
          extras = true;
          keymap = "uk";
        }
      ]
      // myLib.mkIsos [
        "x86_64-linux"
        "aarch64-linux"
      ];
    hm = myLib.mkHm [
      {
        user = "ninel";
        arch = "x86_64-linux";
      }
      {
        user = "9l";
        arch = "x86_64-linux";
      }
    ];
  };
in
self
