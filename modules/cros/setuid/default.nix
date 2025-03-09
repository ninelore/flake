{ lib, pkgs, ... }:
{
  security.wrappers = {
    cbmem = lib.mkDefault {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.cbmem}/bin/cbmem";
    };
    ectool = lib.mkDefault {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.cros-ectool}/bin/ectool";
    };
  };
}
