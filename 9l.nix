{ inputs, pkgs, ... }:
let
  username = "9l";
in
{
  users.users.${username} = {
    shell = pkgs.nushell;
    isNormalUser = true;
    initialPassword = username;
    extraGroups = [
      "networkmanager"
      "power"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "docker"
      "adbusers"
      "plugdev"
      "openrazer"
    ];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [ ./home-manager/home.nix ];
    };
  };
  services.displayManager.autoLogin = {
    user = username;
  };
  security.pam.services.${username}.enableGnomeKeyring = true;
}
