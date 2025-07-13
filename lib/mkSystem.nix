{
  # Username of the main user
  defaultUser ? null,

  # Hostname
  hostName ? "",

  # Extra NixOS modules
  extraModules ? { },

  # Extra Home-Manager modules for defaultUser
  extraHomeModules ? { },

  # Swapfile size if desired
  swapfile ? 0,

  # Nix architecture double, for example "aarch64-linux"
  system ? "x86_64-linux",

  inputs,
  ...
}:
let
  lib = inputs.nixpkgs.lib // inputs.self.lib;
in
{
  ${hostName} = lib.nixosSystem {
    inherit system;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    specialArgs = {
      inherit inputs defaultUser;
    };
    modules = [
      ./../hardware/${hostName}.nix
      inputs.self.nixosModules.default
      inputs.self.nixosModules.ninelore
      inputs.home-manager.nixosModules.home-manager
      {
        networking = { inherit hostName; };
        nixpkgs.hostPlatform = lib.mkDefault system;
        swapDevices = lib.optionals (swapfile > 1) [
          {
            device = "/var/lib/swapfile";
            size = swapfile;
          }
        ];
      }
      (lib.optional (defaultUser != null) {
        users.users.${defaultUser} = {
          isNormalUser = true;
          initialPassword = defaultUser;
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
          ];
        };
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          sharedModules = [ inputs.cosmic-manager.homeManagerModules.cosmic-manager ];
          extraSpecialArgs = {
            inherit inputs defaultUser;
          };
          users.${defaultUser} = {
            imports = [
              inputs.self.homeModules.default
              inputs.self.homeModules.ninelore
              {
                ninelore.gui = lib.mkDefault true;
              }
            ] ++ extraHomeModules;
          };
        };
      })
    ] ++ extraModules;
  };
}
