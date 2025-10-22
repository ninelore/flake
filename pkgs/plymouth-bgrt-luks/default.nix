{
  plymouth,
  stdenv,
  writeText,
  lib,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plymouth-bgrtLuks";
  version = "1";

  # SPDX-License-Identifier: GPL-3.0-only
  src = writeText "bgrt-luks.plymouth" ''
    [Plymouth Theme]
    Name=BGRT-better-luks
    Description=Jimmacs spinner theme using the ACPI BGRT graphics as background with a couple small tweaks to show the LUKS passphrase prompt under the OEM logo.
    ModuleName=two-step

    [two-step]
    Font=Cantarell 12
    TitleFont=Cantarell Light 30
    ImageDir=${plymouth}/share/plymouth/themes/spinner
    DialogHorizontalAlignment=.5
    DialogVerticalAlignment=.7
    TitleHorizontalAlignment=.5
    TitleVerticalAlignment=.382
    HorizontalAlignment=.5
    VerticalAlignment=.7
    WatermarkHorizontalAlignment=.5
    WatermarkVerticalAlignment=.96
    Transition=none
    TransitionDuration=0.0
    BackgroundStartColor=0x000000
    BackgroundEndColor=0x000000
    ProgressBarBackgroundColor=0x606060
    ProgressBarForegroundColor=0xffffff
    DialogClearsFirmwareBackground=false
    MessageBelowAnimation=true

    [boot-up]
    UseEndAnimation=false
    UseFirmwareBackground=true

    [shutdown]
    UseEndAnimation=false
    UseFirmwareBackground=true

    [reboot]
    UseEndAnimation=false
    UseFirmwareBackground=true

    [updates]
    SuppressMessages=true
    ProgressBarShowPercentComplete=true
    UseProgressBar=true
    Title=Installing Updates...
    SubTitle=Do not turn off your computer

    [system-upgrade]
    SuppressMessages=true
    ProgressBarShowPercentComplete=true
    UseProgressBar=true
    Title=Upgrading System...
    SubTitle=Do not turn off your computer

    [firmware-upgrade]
    SuppressMessages=true
    ProgressBarShowPercentComplete=true
    UseProgressBar=true
    Title=Upgrading Firmware...
    SubTitle=Do not turn off your computer
  '';

  dontUnpack = true;
  installPhase = ''
    exit 1
    install -Dm444 $src $out/share/plymouth/themes/bgrt-luks/bgrt-luks.plymouth
  '';

  meta = {
    description = "Plymouth BGRT theme but luks password prompt wont overlap bgrt image";
    license = lib.licenses.gpl3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
