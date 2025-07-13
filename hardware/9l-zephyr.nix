# Partially formerly /etc/nixos/hardware-configuration.nix from 9l-zephyr
{
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
      animeConfig.text = ''
        (
          model_override: None,
          system: [],
          boot: [],
          wake: [],
          shutdown: [],
          display_enabled: false,
          display_brightness: High,
          builtin_anims_enabled: false,
          off_when_unplugged: false,
          off_when_suspended: false,
          off_when_lid_closed: false,
          brightness_on_battery: Low,
          builtin_anims: (
            boot: GlitchConstruction,
            awake: RogLogoGlitch,
            sleep: Starfield,
            shutdown: GlitchOut,
          ),
        )
      '';
    };
    supergfxd.enable = true;
  };

  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "usbhid"
    "sdhci_pci"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/9c50dbd6-3a0b-4b6b-86b0-f326320a27dd";
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D547-AF4A";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
}
