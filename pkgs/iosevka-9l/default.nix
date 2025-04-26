{
  iosevka,
  nerd-font-patcher,
  ...
}:
(iosevka.override {
  privateBuildPlan = builtins.readFile ./private-build-plans.toml;
  set = "_9L";
}).overrideAttrs
  {
    postInstall = ''
      for file in $out/share/fonts/truetype/*; do
      echo "patching nerd font: $file"
      ${nerd-font-patcher}/bin/nerd-font-patcher --variable-width-glyphs --careful -c $file
      done
    '';
  }
