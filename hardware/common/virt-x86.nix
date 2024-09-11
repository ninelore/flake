{ pkgs, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            pkgs.OVMFFull.fd
            pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
          ];
        };
      };
    };
  };
  environment.systemPackages = with pkgs; [
    qemu
  ];
  systemd.tmpfiles.rules =
    let
      firmware = pkgs.runCommandLocal "qemu-firmware" { } ''
        mkdir $out
        cp ${pkgs.qemu}/share/qemu/firmware/*.json $out
        substituteInPlace $out/*.json --replace ${pkgs.qemu} /run/current-system/sw
      '';
    in
    [ "L+ /var/lib/qemu/firmware - - - - ${firmware}" ];
}
