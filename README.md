# My Nix monoflake

## Directory Layout

- 9l: definition of personal outputs
- hardware: Configs equivalent to /etc/nixos/hardware-configuration.nix
- hm: User-level home-manager configs
- lib: Library of custom functions
- modules: custom {nixos,home}Modules
- nix: Nix config module kept compatible as both NixOS and home-manager Module
- pkgs: Custom packages
- sys: System-level Nix(OS) configs

## Iso image commands

- `nix build .#nixosConfigurations.x86_64-linux-iso.config.system.build.isoImage`
- `nix build .#nixosConfigurations.aarch64-linux-iso.config.system.build.isoImage`

## Acknowledgements

- [Aylur](https://github.com/Aylur): [Dotfiles](https://github.com/Aylur/dotfiles) for inspiration and some formerly copied config snippets
