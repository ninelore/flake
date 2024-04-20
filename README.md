# My NixOS config

## Install

1. Clone
2. Change the 2 "changeme" in flake.nix to your target hostname
3. `sudo nixos-rebuild --flake .# --impure`

## ToDo

- get variables hostname, username and system from another file for portability without having to edit those
- save flake path at build for use in an updater script

## Credits

- [Aylur](https://github.com/Aylur): [Dotfiles](https://github.com/Aylur/dotfiles) for inspiration and some copied configs
