# My Nix monoflake

WARNING: Expect force-pushes to main

## Directory Layout

- hardware: Configs equivalent to /etc/nixos/hardware-configuration.nix
- hm: User-level home-manager configs
  - 9l: __Personal__ user and git configuration
- lib: Library of custom functions
- nix: Nix package manager configs and nix overlays
- pkgs: Custom packages
- sys: System-level Nix(OS) configs

## Iso image commands

- `nix build .#nixosConfigurations.x86_64-linux-iso.config.system.build.isoImage`
- `nix build .#nixosConfigurations.aarch64-linux-iso.config.system.build.isoImage`

## Acknowledgements

- [Aylur](https://github.com/Aylur): [Dotfiles](https://github.com/Aylur/dotfiles) for inspiration and some formerly copied config snippets
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim): Should be self-explainatory
