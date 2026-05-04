# My Nix monoflake

This flake harbors various custom derivations and modules for Nix, NixOS and Home-Manager.

## Modules

- **default**: Simply adds the package overlay and the binary cache
- **cros**: Provides some configuration for Chromebooks. 
  - Installs Firmware via `hardware.enableRedistributableFirmware = true;`
  - Installs [WeirdTreeThing's UCMs](https://github.com/WeirdTreeThing/alsa-ucm-conf-cros)
    - Does not install modprobe configs that might be required!
  - Installs keyd and libinput, but **no** configuration. Run [cros-keyboard-map]() to generate configuration.
  - Enebles iio for screen rotation.
  - Disables TPM.
  - Will **not** override your configuration.
- **crosSetuid**: Installs `ectool` and `cbmem` with setuid permission to PATH
- **crosAarch64**: Fixes and slims down NixOS initrd for aarch64 and custom kernels

## Packages

tbd

### Images

The images include additional useful tools in addition to the NixOS ISO defaults.

The following images are production ready and are [built by CI](https://github.com/ninelore/flake/actions/workflows/images.yml)

## License

This flake is licensed under the [MIT License](LICENSE.md).

Note: MIT license does not apply to the packages built by this flake,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to which
they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.
