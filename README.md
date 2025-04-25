# My Nix monoflake

This flake harbors custom package derivations, image generation outputs as well as my personal configurations for Nix, NixOS as well as Home-Manager.

## Images

The images always include additional useful tool in addition to the NixOS ISO defaults and are preconfigured to run NetworkManager for Connectivity.

The following images are production ready and are [built by CI](https://github.com/ninelore/flake/actions/workflows/images.yml)

- **`raw-x64cros`**: Raw disk image for Chromebooks. While these are intended for stock (Depthcharge) firmware, they can be used for UEFI Firmware aswell.
  - Architecture: x86_64-linux
  - Latest NixOS stable kernel (`pkgs.linuxPackages_latest`)
  - Layout:
    - 1: 64MiB [Submarine](https://github.com/fyralabs/submarine)
    - 2: ~320MiB EFI Partition for BLS entries, but also featuring `systemd-boot`
    - 3: ~8GiB expanding ext4 root partiton
- **`iso-x86_64`**: Iso image for x86_64 UEFI. Basically like the NixOS minimal iso, but with extra tools, NetworkManager and the latest stable kernel.
  - Architecture: x86_64-linux
  - Latest NixOS stable kernel (`pkgs.linuxPackages_latest`)
  - Layout: ISO 9660 image

### Build Instructions

Refer to [`./lib/images.nix`](lib/images.nix) for a list of all available images.

<details>
<summary>Instructions for non-NixOS</summary>

1. Have nix installed and the experimental features `nix-command flakes` enabled
2. ´nix run nixpkgs#cachix -- use 9lore`
3. ´nix build github:ninelore/flake#nixosImages.<Image>´
4. Image will be in `./result/` or `./result/iso/`

</details>

<details>
<summary>Instructions for NixOS</summary>
  
1. Have the experimental features `nix-command flakes` enabled
2. Add the default module of this flake to your configuration to add the binary cache and overlay. Alternatively [follow the instructions here](https://app.cachix.org/cache/9lore)
3. ´nix build github:ninelore/flake#nixosImages.<Image>´
4. Image will be in `./result/` or `./result/iso/`

</details>

## Acknowledgements

- [Aylur](https://github.com/Aylur): [Dotfiles](https://github.com/Aylur/dotfiles) for inspiration and some formerly copied config snippets
