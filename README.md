# My Nix monoflake

## Directory Layout

- modules: Custom {nixos,home}Modules
- pkgs: Package Derivations
- 9l: Personal outputs and configuration
    - hardware: Configs equivalent to /etc/nixos/hardware-configuration.nix
    - hm: User-level home-manager configs
    - lib: Library of custom functions
    - nixcfg: Nix config module kept compatible as both NixOS and home-manager modules
    - nixos: System-level NixOS configs

## Images

Refer to `./lib/images.nix` on available images.

Images can be built with `nix build .#nixosImages.<name>`

## Acknowledgements

- [Aylur](https://github.com/Aylur): [Dotfiles](https://github.com/Aylur/dotfiles) for inspiration and some formerly copied config snippets
