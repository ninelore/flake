{ pkgs, systemConfig, ... }:
{
  imports = [
    ./system.nix
    ./locale.nix
    ./userland.nix
    ./smb.nix
  ];

  users.users.${systemConfig.username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = systemConfig.username;
    extraGroups = [
      "networkmanager"
      "power"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "docker"
      "podman"
      "adbusers"
      "plugdev"
      "openrazer"
      "wireshark"
      "ydotool"
      "dialout"
      "ninelsmb"
    ];
  };

  documentation.nixos.enable = false;

  networking = {
    hostName = systemConfig.hostname;
    networkmanager.enable = true;
    firewall = rec {
      enable = true;
      allowPing = false;
      allowedTCPPortRanges = [ ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    hosts = {
      "127.0.0.1" = [
        "localhost"
        "lolcathost"
      ];
    };
  };

  system.stateVersion = "24.05";
}
