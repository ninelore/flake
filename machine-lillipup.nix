# Google Lillipup

{ config, pkgs, ... }:

{
  networking.hostName = "9l-lillipup-nix";

  boot.extraModprobeConfig = 
    ''
    options snd-intel-dspcfg dsp_driver=3
    '';

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
  ];

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;

  hardware.firmware = with pkgs; [
    sof-firmware
  ];

  environment.systemPackages = with pkgs; [
    sof-firmware
    alsa-ucm-conf
  ];

  hardware.enableAllFirmware = true;

}