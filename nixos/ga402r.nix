{config, ...}: {
  modesetting.enable = true;

  # asusctl
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  services.supergfxd.enable = true;

}
