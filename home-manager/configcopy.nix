{
  pkgs,
  ...
}: {
  xdg.configFile = {
    anyrun.source = ../configs/anyrun;
  }
}