{ systemConfig, ... }:
{
  imports = [
    ./system.nix
    ./locale.nix
    ./userland.nix
    ./virt.nix
  ];

  users.users.${systemConfig.username} = {
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
      "adbusers"
      "plugdev"
      "openrazer"
      "wireshark"
      "ydotool"
    ];
  };

  documentation.nixos.enable = false;

  networking = {
    hostName = systemConfig.hostname;
    networkmanager.enable = true;
    firewall = rec {
      allowedTCPPortRanges = [
        # Example
        #{
        #  from = 1714;
        #  to = 1764;
        #}
      ];
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
