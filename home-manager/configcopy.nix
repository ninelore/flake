{ pkgs
, ...
}: {
  xdg.configFile = {
    anyrun.source = ../configs/anyrun;
    ranger.source = ../configs/ranger;
    kitty.source = ../configs/kitty;
  };
}
