{ pkgs, ... }:
{
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };
}
