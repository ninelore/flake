{ pkgs }:
let
  bgrtLuks = pkgs.stdenv.mkDerivation {
    name = "bgrtLuks";

    src = pkgs.writeText "bgrt-luks.plymouth" ''
      [Plymouth Theme]
      Name=BGRT-better-luks
      Description=Jimmacs spinner theme using the ACPI BGRT graphics as background with a couple small tweaks to show the LUKS passphrase prompt under the OEM logo.
      ModuleName=two-step

      [two-step]
      Font=Cantarell 12
      TitleFont=Cantarell Light 30
      ImageDir=${pkgs.plymouth}/share/plymouth/themes/spinner
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
      install -Dm444 $src $out/share/plymouth/themes/bgrt-luks/bgrt-luks.plymouth
    '';
  };
in {
  boot = {
    consoleLogLevel = 2;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    plymouth = {
      enable = true;
      theme = "bgrt-luks";
      themePackages = [ bgrtLuks ];
    };
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=error" "rd.udev.log_level=2" "udev.log_priority=2" "boot.shell_on_fail" ];

    tmp.cleanOnBoot = true;
    #supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };
}