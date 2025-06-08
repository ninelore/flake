{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "adwaita-kvantum";

  src = fetchFromGitHub {
    owner = "GabePoel";
    repo = "KvLibadwaita";
    rev = "87c1ef9f44ec48855fd09ddab041007277e30e37";
    sha256 = "sha256-xBl6zmpqTAH5MIT5iNAdW6kdOcB5MY0Dtrb95hdYpwA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum
    cp -a src/* $out/share/Kvantum
    runHook postInstall
  '';

  meta = with lib; {
    description = "Libadwaita theme for Kvantum";
    homepage = "https://github.com/GabePoel/KvLibadwaita";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
