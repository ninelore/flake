{ pkgs, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./audio.nix
    ./locale.nix
    ./login.nix
    ./hyprland.nix
    #./ga402r.nix
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
    consoleLogLevel = 2;
    initrd.verbose = false;
    plymouth.enable = true;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=error" "rd.udev.log_level=2" "udev.log_priority=2" "boot.shell_on_fail" ];

    tmp.cleanOnBoot = true;
    #supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
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
