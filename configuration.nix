################################
##                            ##
##    ninelore's nix config   ##
##                            ##
################################

# Docs: ‘nixos-help’, configuration.nix(5) man page

# Symlink the right machine config to machine.nix!


{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./machine.nix
    ];

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.editor = false;

    timeout = 1;

    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  console.keyMap = "de";
  services.input-remapper.enable = true;

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    #media-session.enable = true;
  };

  services.xserver.libinput.enable = true;

  users.users.ninelore = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "power" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    htop.enable = true;
    less.enable = true;
    npm.enable = true;
    git.enable = true;
    #waybar.enable = true;
    xwayland.enable = true;
    zsh = {
      enable = true;
      # TODO: Move zsh configs?
      ohMyZsh = {
        enable = true;
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      # TODO: move and redo config?
    };
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    #hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #};
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    gh
    gimp
    hugo
    neofetch
    gnumake
    pavucontrol
    w3m
    ranger
    freetype
    dotnet-sdk_7
    rustup
    powershell
    trash-cli
    unzip
    go
    nodejs_18
    keyd
    vscode
    libreoffice-qt
    discord
    jetbrains-toolbox
    python3

    sof-firmware
    alsa-ucm-conf
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    jetbrains-mono
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  system.autoUpgrade.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.05"; # Be careful here

}
