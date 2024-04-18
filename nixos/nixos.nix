{ pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./audio.nix
      ./locale.nix
      ./ga402r.nix
    ];

  documentation.nixos.enable = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  programs.virt-manager.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    libvirtd.enable = true;
  };

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandleLidSwitch=suspend
    HandleLidSwitchDocked=ignore
  '';

  services = {
    #printing.enable = true;
    flatpak.enable = true;
  };

  networking.networkmanager.enable = true;

  networking.firewall = rec {
    allowedTCPPortRanges = [
      #{
      #  from = 1714;
      #  to = 1764;
      #}
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.openrazer.enable = true;

  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    gh
    home-manager
    neovim
  ];

  system.stateVersion = "23.05";
}
