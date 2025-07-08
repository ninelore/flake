{ inputs, ... }:
let
  myLib = import ./lib { inherit inputs; };
  self = {
    nixos = myLib.mkNixos [
      {
        username = "9l";
        hostname = "9l-zephyr";
        architecture = "x86_64-linux";
        keymap = "de";
      }
      {
        username = "9l";
        hostname = "9l-drobit";
        architecture = "x86_64-linux";
        keymap = "uk";
      }
      {
        username = "9l";
        hostname = "9l-tomato";
        architecture = "aarch64-linux";
        keymap = "uk";
      }
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
