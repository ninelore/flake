{
  fetchgit,
  lib,
  python3Packages,
  ...
}:
with python3Packages;
buildPythonApplication rec {
  name = "depthcharge-tools";
  version = "0.6.2";
  src = fetchgit {
    url = "https://github.com/alpernebbi/depthcharge-tools";
    hash = "sha256-3xPRNDUXLOwYy8quMfYSiBfzQl4peauTloqtZBGbvlw=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Tools to manage the Chrome OS bootloader ";
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

}
