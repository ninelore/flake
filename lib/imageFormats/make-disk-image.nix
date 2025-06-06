/*
  Technical details

  `make-disk-image` has a bit of magic to minimize the amount of work to do in a virtual machine. It also might arguably have too much, or at least too specific magic, so please consider to work towards the effort of unifying our image builders, as outlined in https://github.com/NixOS/nixpkgs/issues/324817 before adding more.

  It relies on the [LKL (Linux Kernel Library) project](https://github.com/lkl/linux) which provides Linux kernel as userspace library.

  The Nix-store only image only need to run LKL tools to produce an image and will never spawn a virtual machine, whereas full images will always require a virtual machine, but also use LKL.

  ### Image preparation phase

  Image preparation phase will produce the initial image layout in a folder:

  - devise a root folder based on `$PWD`
  - prepare the contents by copying and restoring ACLs in this root folder
  - load in the Nix store database all additional paths computed by `pkgs.closureInfo` in a temporary Nix store
  - run `nixos-install` in a temporary folder
  - transfer from the temporary store the additional paths registered to the installed NixOS
  - compute the size of the disk image based on the apparent size of the root folder
  - partition the disk image using the corresponding script according to the partition table type
  - format the partitions if needed
  - use `cptofs` (LKL tool) to copy the root folder inside the disk image

  At this step, the disk image already contains the Nix store, it now only needs to be converted to the desired format to be used.

  ### Image conversion phase

  Using `qemu-img`, the disk image is converted from a raw format to the desired format: qcow2(-compressed), vdi, vpc.

  ### Image Partitioning

  This partition table type uses GPT and:

  - creates a 64MB Partiton for Fyra Labs Submarine, which will be marked as a ChromeOS Kernel Partition ;
  - creates an FAT32 ESP partition from 8MiB to specified `bootSize` parameter (256MiB by default), set it bootable ;
  - creates an primary ext4 partition starting after the boot partition and extending to the full disk image

  ### How to run determinism analysis on results?

  Build your derivation with `--check` to rebuild it and verify it is the same.

  If it fails, you will be left with two folders with one having `.check`.

  You can use `diffoscope` to see the differences between the folders.

  However, `diffoscope` is currently not able to diff two QCOW2 filesystems, thus, it is advised to use raw format.

  Even if you use raw disks, `diffoscope` cannot diff the partition table and partitions recursively.

  To solve this, you can run `fdisk -l $image` and generate `dd if=$image of=$image-p$i.raw skip=$start count=$sectors` for each `(start, sectors)` listed in the `fdisk` output. Now, you will have each partition as a separate file and you can compare them in pairs.
*/
{
  pkgs,
  lib,

  # The NixOS configuration to be installed onto the disk image.
  config,

  # The size of the disk, in megabytes.
  # if "auto" size is calculated based on the contents copied to it and
  #   additionalSpace is taken into account.
  diskSize ? "auto",

  # additional disk space to be added to the image if diskSize "auto"
  # is used
  additionalSpace ? "512M",

  # size of the boot partition, is only used if partitionTableType is
  # either "efi" or "hybrid"
  # This will be undersized slightly, as this is actually the offset of
  # the end of the partition. Generally it will be 1MiB smaller.
  # It should be at least 300M (MiB) due to Submarine
  bootSize ? "768M",

  # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target, mode, user, group} where
  # `source' is the file system object (regular file or directory) to be
  # grafted in the file system at path `target', `mode' is a string containing
  # the permissions that will be set (ex. "755"), `user' and `group' are the
  # user and group name that will be set as owner of the files.
  # `mode', `user', and `group' are optional.
  # When setting one of `user' or `group', the other needs to be set too.
  contents ? [ ],

  # Whether to output have EFIVARS available in $out/efi-vars.fd and use it during disk creation
  touchEFIVars ? false,

  # OVMF firmware derivation
  OVMF ? pkgs.OVMF.fd,

  # EFI firmware
  efiFirmware ? OVMF.firmware,

  # EFI variables
  efiVariables ? OVMF.variables,

  # The root file system type.
  fsType ? "ext4",

  # Filesystem label
  label ? "NIXOS",

  # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix.
  configFile ? null,

  # Shell code executed after the VM has finished.
  postVM ? "",

  # Guest memory size
  memSize ? 8192,

  name ? "nixos-disk-image",

  # Disk image filename, without any extensions (e.g. `image_1`).
  baseName ? "nixos_cros-${pkgs.system}",

  # Whether to fix:
  #   - GPT Disk Unique Identifier (diskGUID)
  #   - GPT Partition Unique Identifier: depends on the layout, root partition UUID can be controlled through `rootGPUID` option
  #   - GPT Partition Type Identifier: fixed according to the layout, e.g. ESP partition, etc. through `parted` invocation.
  #   - Filesystem Unique Identifier when fsType = ext4 for *root partition*.
  # BIOS/MBR support is "best effort" at the moment.
  # Boot partitions may not be deterministic.
  # Also, to fix last time checked of the ext4 partition if fsType = ext4.
  deterministic ? true,

  # GPT Partition Unique Identifier for root partition.
  rootGPUID ? "F222513B-DED1-49FA-B591-20CE86A2FE7F",
  # When fsType = ext4, this is the root Filesystem Unique Identifier.
  # TODO: support other filesystems someday.
  rootFSUID ? (if fsType == "ext4" then rootGPUID else null),

  # Whether a nix channel based on the current source tree should be
  # made available inside the image. Useful for interactive use of nix
  # utils, but changes the hash of the image when the sources are
  # updated.
  copyChannel ? true,

  # Additional store paths to copy to the image's store.
  additionalPaths ? [ ],
}:

assert (
  lib.assertMsg (fsType == "ext4" && deterministic -> rootFSUID != null)
    "In deterministic mode with a ext4 partition, rootFSUID must be non-null, by default, it is equal to rootGPUID."
);
# Either both or none of {user,group} need to be set
assert (
  lib.assertMsg (lib.all (
    attrs: ((attrs.user or null) == null) == ((attrs.group or null) == null)
  ) contents) "Contents of the disk image should set none of {user, group} or both at the same time."
);

let
  submarineSystem =
    {
      "aarch64-linux" = "a64";
      "x86_64-linux" = "x86";
    }
    .${pkgs.system};

  filename = "${baseName}.img";

  partitionDiskScript = ''
    parted --script $diskImage -- \
      mklabel gpt \
      mkpart SUBMARINE 4MiB 68MiB \
      align-check optimal 1 \
      mkpart ESP fat32 68MiB $bootSizeMiB \
      set 2 boot on \
      align-check optimal 2 \
      mkpart NIXOS ext4 $bootSizeMiB 100% \
      align-check optimal 3 \
      print
    ${lib.optionalString deterministic ''
      sgdisk \
      --disk-guid=97FD5997-D90B-4AA3-8D16-C1723AEA73C \
      --partition-guid=2:1C06F03B-704E-4657-B9CD-681A087A2FDC \
      --partition-guid=3:${rootGPUID} \
      $diskImage
    ''}
  '';

  useEFIBoot = touchEFIVars;

  nixpkgs = lib.cleanSource pkgs.path;

  # FIXME: merge with channel.nix / make-channel.nix.
  channelSources = pkgs.runCommand "nixos-${config.system.nixos.version}" { } ''
    mkdir -p $out
    cp -prd ${nixpkgs.outPath} $out/nixos
    chmod -R u+w $out/nixos
    if [ ! -e $out/nixos/nixpkgs ]; then
      ln -s . $out/nixos/nixpkgs
    fi
    rm -rf $out/nixos/.git
    echo -n ${config.system.nixos.versionSuffix} > $out/nixos/.version-suffix
  '';

  binPath = lib.makeBinPath (
    with pkgs;
    [
      rsync
      util-linux
      parted
      e2fsprogs
      lkl
      config.system.build.nixos-install
      nixos-enter
      nix
      systemdMinimal
      vboot_reference
    ]
    ++ lib.optional deterministic gptfdisk
    ++ stdenv.initialPath
  );

  # I'm preserving the line below because I'm going to search for it across nixpkgs to consolidate
  # image building logic. The comment right below this now appears in 4 different places in nixpkgs :)
  # !!! should use XML.
  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;
  modes = map (x: x.mode or "''") contents;
  users = map (x: x.user or "''") contents;
  groups = map (x: x.group or "''") contents;

  basePaths = [ config.system.build.toplevel ] ++ lib.optional copyChannel channelSources;

  additionalPaths' = lib.subtractLists basePaths additionalPaths;

  closureInfo = pkgs.closureInfo {
    rootPaths = basePaths ++ additionalPaths';
  };

  blockSize = toString (4 * 1024); # ext4fs block size (not block device sector size)

  prepareImage = ''
    export PATH=${binPath}

    # Yes, mkfs.ext4 takes different units in different contexts. Fun.
    sectorsToKilobytes() {
      echo $(( ( "$1" * 512 ) / 1024 ))
    }

    sectorsToBytes() {
      echo $(( "$1" * 512  ))
    }

    # Given lines of numbers, adds them together
    sum_lines() {
      local acc=0
      while read -r number; do
        acc=$((acc+number))
      done
      echo "$acc"
    }

    mebibyte=$(( 1024 * 1024 ))

    # Approximative percentage of reserved space in an ext4 fs over 512MiB.
    # 0.05208587646484375
    #  × 1000, integer part: 52
    compute_fudge() {
      echo $(( $1 * 52 / 1000 ))
    }

    round_to_nearest() {
      echo $(( ( $1 / $2 + 1) * $2 ))
    }

    mkdir $out

    root="$PWD/root"
    mkdir -p $root

    # Copy arbitrary other files into the image
    # Semi-shamelessly copied from make-etc.sh.
    set -f
    sources_=(${lib.concatStringsSep " " sources})
    targets_=(${lib.concatStringsSep " " targets})
    modes_=(${lib.concatStringsSep " " modes})
    set +f

    for ((i = 0; i < ''${#targets_[@]}; i++)); do
      source="''${sources_[$i]}"
      target="''${targets_[$i]}"
      mode="''${modes_[$i]}"

      if [ -n "$mode" ]; then
        rsync_chmod_flags="--chmod=$mode"
      else
        rsync_chmod_flags=""
      fi
      # Unfortunately cptofs only supports modes, not ownership, so we can't use
      # rsync's --chown option. Instead, we change the ownerships in the
      # VM script with chown.
      rsync_flags="-a --no-o --no-g $rsync_chmod_flags"
      if [[ "$source" =~ '*' ]]; then
        # If the source name contains '*', perform globbing.
        mkdir -p $root/$target
        for fn in $source; do
          rsync $rsync_flags "$fn" $root/$target/
        done
      else
        mkdir -p $root/$(dirname $target)
        if [ -e $root/$target ]; then
          echo "duplicate entry $target -> $source"
          exit 1
        elif [ -d $source ]; then
          # Append a slash to the end of source to get rsync to copy the
          # directory _to_ the target instead of _inside_ the target.
          # (See `man rsync`'s note on a trailing slash.)
          rsync $rsync_flags $source/ $root/$target
        else
          rsync $rsync_flags $source $root/$target
        fi
      fi
    done

    export HOME=$TMPDIR

    # Provide a Nix database so that nixos-install can copy closures.
    export NIX_STATE_DIR=$TMPDIR/state
    nix-store --load-db < ${closureInfo}/registration

    chmod 755 "$TMPDIR"
    echo "running nixos-install..."
    nixos-install --root $root --no-bootloader --no-root-passwd \
      --system ${config.system.build.toplevel} \
      ${if copyChannel then "--channel ${channelSources}" else "--no-channel-copy"} \
      --substituters ""

    ${lib.optionalString (additionalPaths' != [ ]) ''
      nix --extra-experimental-features nix-command copy --to $root --no-check-sigs ${lib.concatStringsSep " " additionalPaths'}
    ''}

    diskImage=nixos.raw

    bootSize=$(round_to_nearest $(numfmt --from=iec '${bootSize}') $mebibyte)
    bootSizeMiB=$(( bootSize / 1024 / 1024 ))MiB

    ${
      if diskSize == "auto" then
        ''
          # Add the GPT at the end
          gptSpace=$(( 512 * 34 * 1 ))

          # Normally we'd need to account for alignment and things, if bootSize
          # represented the actual size of the boot partition. But it instead
          # represents the offset at which it ends.
          # So we know bootSize is the reserved space in front of the partition.
          reservedSpace=$(( gptSpace + bootSize ))

          additionalSpace=$(( $(numfmt --from=iec '${additionalSpace}') + reservedSpace ))

          # Compute required space in filesystem blocks
          diskUsage=$(find . ! -type d -print0 | du --files0-from=- --apparent-size --count-links --block-size "${blockSize}" | cut -f1 | sum_lines)
          # Each inode takes space!
          numInodes=$(find . | wc -l)
          # Convert to bytes, inodes take two blocks each!
          diskUsage=$(( (diskUsage + 2 * numInodes) * ${blockSize} ))
          # Then increase the required space to account for the reserved blocks.
          fudge=$(compute_fudge $diskUsage)
          requiredFilesystemSpace=$(( diskUsage + fudge ))

          # Round up to the nearest block size.
          # This ensures whole $blockSize bytes block sizes in the filesystem
          # and helps towards aligning partitions optimally.
          requiredFilesystemSpace=$(round_to_nearest $requiredFilesystemSpace ${blockSize})

          diskSize=$(( requiredFilesystemSpace + additionalSpace ))

          # Round up to the nearest mebibyte.
          # This ensures whole 512 bytes sector sizes in the disk image
          # and helps towards aligning partitions optimally.
          diskSize=$(round_to_nearest $diskSize $mebibyte)

          truncate -s "$diskSize" $diskImage

          printf "Automatic disk size...\n"
          printf "  Closure space use: %d bytes\n" $diskUsage
          printf "  fudge: %d bytes\n" $fudge
          printf "  Filesystem size needed: %d bytes\n" $requiredFilesystemSpace
          printf "  Additional space: %d bytes\n" $additionalSpace
          printf "  Disk image size: %d bytes\n" $diskSize
        ''
      else
        ''
          truncate -s ${toString diskSize}M $diskImage
        ''
    }

    ${partitionDiskScript}

    # Get start & length of the root partition in sectors to $START and $SECTORS.
    eval $(partx $diskImage -o START,SECTORS --nr 3 --pairs)

    mkfs.${fsType} -b ${blockSize} -F -L ${label} $diskImage -E offset=$(sectorsToBytes $START) $(sectorsToKilobytes $SECTORS)K

    echo "copying staging root to image..."
    cptofs -p -P 3 \
           -t ${fsType} \
           -i $diskImage \
           $root/* / ||
      (echo >&2 "ERROR: cptofs failed. diskSize might be too small for closure."; exit 1)
  '';

  moveOrConvertImage = ''
    mv $diskImage $out/${filename}
    diskImage=$out/${filename}
  '';

  createEFIVars = ''
    efiVars=$out/efi-vars.fd
    cp ${efiVariables} $efiVars
    chmod 0644 $efiVars
  '';

  createHydraBuildProducts = ''
    mkdir -p $out/nix-support
    echo "file raw-image $out/${filename}" >> $out/nix-support/hydra-build-products
  '';

  buildImage = pkgs.vmTools.runInLinuxVM (
    pkgs.runCommand name
      {
        preVM = prepareImage + lib.optionalString touchEFIVars createEFIVars;
        buildInputs = with pkgs; [
          util-linux
          e2fsprogs
          dosfstools
          vboot_reference
          submarine
        ];
        postVM = moveOrConvertImage + createHydraBuildProducts + postVM;
        QEMU_OPTS = lib.concatStringsSep " " (
          lib.optional useEFIBoot "-drive if=pflash,format=raw,unit=0,readonly=on,file=${efiFirmware}"
          ++ lib.optionals touchEFIVars [
            "-drive if=pflash,format=raw,unit=1,file=$efiVars"
          ]
          ++ lib.optionals (OVMF.systemManagementModeRequired or false) [
            "-machine"
            "q35,smm=on"
            "-global"
            "driver=cfi.pflash01,property=secure,value=on"
          ]
        );
        inherit memSize;
      }
      ''
        export PATH=${binPath}:$PATH

        rootDisk=${"/dev/vda3"}

        # Install submarine
        cgpt add -i 1 -t kernel -P 15 -T 1 -S 1 /dev/vda
        dd if=${pkgs.submarine}/share/submarine/submarine-${submarineSystem}.kpart of=/dev/vda1

        # It is necessary to set root filesystem unique identifier in advance, otherwise
        # bootloader might get the wrong one and fail to boot.
        # At the end, we reset again because we want deterministic timestamps.
        ${lib.optionalString (fsType == "ext4" && deterministic) ''
          tune2fs -T now ${lib.optionalString deterministic "-U ${rootFSUID}"} -c 0 -i 0 $rootDisk
        ''}
        # make systemd-boot find ESP without udev
        mkdir /dev/block
        ln -s /dev/vda2 /dev/block/254:2

        mountPoint=/mnt
        mkdir $mountPoint
        mount $rootDisk $mountPoint

        # Create the ESP and mount it. Unlike e2fsprogs, mkfs.vfat doesn't support an
        # '-E offset=X' option, so we can't do this outside the VM.
        mkdir -p /mnt/boot
        mkfs.vfat -n ESP /dev/vda2
        mount /dev/vda2 /mnt/boot

        ${lib.optionalString touchEFIVars "mount -t efivarfs efivarfs /sys/firmware/efi/efivars"}

        # Install a configuration.nix
        mkdir -p /mnt/etc/nixos
        ${lib.optionalString (configFile != null) ''
          cp ${configFile} /mnt/etc/nixos/configuration.nix
        ''}

        # In this throwaway resource, we only have /dev/vda, but the actual VM may refer to another disk for bootloader, e.g. /dev/vdb
        # Use this option to create a symlink from vda to any arbitrary device you want.
        ${lib.optionalString (config.boot.loader.grub.enable) (
          lib.concatMapStringsSep " " (
            device:
            lib.optionalString (device != "/dev/vda") ''
              mkdir -p "$(dirname ${device})"
              ln -s /dev/vda ${device}
            ''
          ) config.boot.loader.grub.devices
        )}

        # Set up core system link, bootloader (sd-boot, GRUB, uboot, etc.), etc.

        # NOTE: systemd-boot-builder.py calls nix-env --list-generations which
        # clobbers $HOME/.nix-defexpr/channels/nixos This would cause a  folder
        # /homeless-shelter to show up in the final image which  in turn breaks
        # nix builds in the target image if sandboxing is turned off (through
        # __noChroot for example).
        export HOME=$TMPDIR
        NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root $mountPoint -- /nix/var/nix/profiles/system/bin/switch-to-configuration boot

        # Set the ownerships of the contents. The modes are set in preVM.
        # No globbing on targets, so no need to set -f
        targets_=(${lib.concatStringsSep " " targets})
        users_=(${lib.concatStringsSep " " users})
        groups_=(${lib.concatStringsSep " " groups})
        for ((i = 0; i < ''${#targets_[@]}; i++)); do
          target="''${targets_[$i]}"
          user="''${users_[$i]}"
          group="''${groups_[$i]}"
          if [ -n "$user$group" ]; then
            # We have to nixos-enter since we need to use the user and group of the VM
            nixos-enter --root $mountPoint -- chown -R "$user:$group" "$target"
          fi
        done

        umount -R /mnt

        # Make sure resize2fs works. Note that resize2fs has stricter criteria for resizing than a normal
        # mount, so the `-c 0` and `-i 0` don't affect it. Setting it to `now` doesn't produce deterministic
        # output, of course, but we can fix that when/if we start making images deterministic.
        # In deterministic mode, this is fixed to 1970-01-01 (UNIX timestamp 0).
        # This two-step approach is necessary otherwise `tune2fs` will want a fresher filesystem to perform
        # some changes.
        ${lib.optionalString (fsType == "ext4") ''
          tune2fs -T now ${lib.optionalString deterministic "-U ${rootFSUID}"} -c 0 -i 0 $rootDisk
          ${lib.optionalString deterministic "tune2fs -f -T 19700101 $rootDisk"}
        ''}
      ''
  );
in
buildImage
