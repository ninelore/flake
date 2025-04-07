# My Nix monoflake

## Directory Layout

- modules: Custom {nixos,home}Modules
- pkgs: Package Derivations
- 9l: Personal outputs and configuration
    - hardware: Configs equivalent to /etc/nixos/hardware-configuration.nix
    - hm: User-level home-manager configs
    - lib: Library of custom functions
    - nixcfg: Nix config module kept compatible as both NixOS and home-manager modules
    - sys: System-level Nix(OS) configs

## Iso image commands

- `nix build .#nixosConfigurations.x86_64-linux-iso.config.system.build.isoImage`
- `nix build .#nixosConfigurations.aarch64-linux-iso.config.system.build.isoImage`

## Acknowledgements

- [Aylur](https://github.com/Aylur): [Dotfiles](https://github.com/Aylur/dotfiles) for inspiration and some formerly copied config snippets
