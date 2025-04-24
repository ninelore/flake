{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.cros
    inputs.self.nixosModules.crosSetuid
  ];
  systemd.services."getty@tty11" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };
}
