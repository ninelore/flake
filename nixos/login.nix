{ config, lib, pkgs, ... }:
let
#  chiliCustom = pkgs.stdenv.mkDerivation rec {
#    name = "chili";
#    version = "0.1.5";
#    src = pkgs.fetchFromGitHub {
#      owner = "MarianArlt";
#      repo = "sddm-${name}";
#      rev = version;
#      sha256 = "036fxsa7m8ymmp3p40z671z163y6fcsa9a641lrxdrw225ssq5f3";
#    };
#    # https://w.wallhaven.cc/full/r2/wallhaven-r2pmx1.jpg
#    themeIni = [
#      { section = "General"; key = "background"; value = ../assets/wallhaven-r2pmx1.jpg; }
#    ];
#
#    pname = "sddm-theme-${name}";
#    buildCommand = ''
#      dir=$out/share/sddm/themes/${name}
#      doc=$out/share/doc/${pname}
#
#      mkdir -p $dir $doc
#      if [ -d $src/${name} ]; then
#        srcDir=$src/${name}
#      else
#        srcDir=$src
#      fi
#      cp -r $srcDir/* $dir/
#      for f in $dir/{AUTHORS,COPYING,LICENSE,README,*.md,*.txt}; do
#        test -f $f && mv $f $doc/
#      done
#      chmod 444 $dir/theme.conf
#
#      ${lib.concatMapStringsSep "\n" (e: ''
#        ${pkgs.crudini}/bin/crudini --set --inplace $dir/theme.conf \
#          "${e.section}" "${e.key}" "${e.value}"
#      '') themeIni}
#    '';
#  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
    #extraPackages = [ chiliCustom ];
    enableHidpi = true;
    autoNumlock = true;
  };
}
