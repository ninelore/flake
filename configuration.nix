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

  hardware.opengl.enable = true;

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

  console.keyMap = "de-latin1";

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
  
  # TODO: add custom PATH stuff
  #environment.profileRelativeEnvVars

  environment.localBinInPath = true;

  nixpkgs.config.allowUnfree = true;

  programs = {
    htop.enable = true;
    less.enable = true;
    git.enable = true;
    waybar.enable = false;
    xwayland.enable = true;
    zsh = {
      enable = true;
      histFile = "$HOME/.histfile";
      histSize = 1000;
      #setOptions = [
      #  "HYPHEN_INSENSITIVE"
      #  "COMPLETION_WAITING_DOTS"
      #];
      shellAliases = {
        "v" = "nvim";
        "untar" = "tar -xavf";
        "l." = "ls -d .* --color=auto";
        "sv" = "sudo nvim";
        "root" = "sudo -i";
        "su" = "sudo -i";
        "r" = "ranger";
        "sr" = "sudo ranger";
        "c" = "clear";
        "cryptopen" = "sudo cryptsetup open";
        "cryptclose" = "sudo cryptsetup close";
        "py" = "python3";
        "cdo" = "cd $OLDPWD";
        "grep" = "grep --color=auto";
        "pullall" = "for i in *; do if [[ -d $i/.git ]]; then cd $i; git pull; cd ..; fi; done";

        "cleanup" ="sudo nix-collect-garbage --delete-older-than 7d && sudo nixos-rebuild switch";
        "upall" = "sudo nix-channel --update && sudo nixos-rebuild switch --upgrade";
        "rebuild" = "sudo nixos-rebuild switch";
      };
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        #plugins = [
        #  "git"
        #];
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      # TODO: move and redo config
    };
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    hyprland = {
      enable = false;
      xwayland.enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    firefox
    microsoft-edge
    gh
    git
    gimp
    hugo
    flyctl
    neofetch
    gnumake
    pavucontrol
    w3m
    ranger
    freetype
    gcc
    dotnet-sdk_7
    rustup
    ruby
    powershell
    trash-cli
    unzip
    go
    nodejs_18
    krita
    vscode
    libreoffice-qt
    discord
    jetbrains-toolbox
    python3
    tree
    sddm-kcm
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
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
