{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  security.pam.services.kwallet.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };
}
