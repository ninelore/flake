# Google Lillipup

{ config, pkgs, ... }:

{
  networking.hostName = "9l-lillipup-nix";

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
  ];
  hardware.firmware = with pkgs; [
    sof-firmware
  ];

}