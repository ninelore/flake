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
      "wireshark"
    ];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      pkgs-small = import inputs.nixpkgs-small {
        system = pkgs.system;
        config.allowUnfree = true;
      };
    };
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";

      imports = [
        ./home-manager/home.nix
        ./home-manager/git9l.nix
      ];
    };
  };
  #services.displayManager.autoLogin = {
  #  user = username;
  #};
}
