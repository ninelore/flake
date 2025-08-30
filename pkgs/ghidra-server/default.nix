{
  lib,
  stdenv,
  ghidra,
  jdk,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (ghidra) version;
  pname = "ghidra-server";

  src = ghidra;

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/{bin,lib,share}

    cp -r $src/lib/ghidra $out/lib/ghidra

    mkdir -p $out/share/java
    ln -s $out/lib/ghidra/Ghidra/Features/GhidraServer/lib/GhidraServer.jar $out/share/java
    ln -s $out/lib/ghidra/Ghidra/Framework/FileSystem/lib/FileSystem.jar $out/share/java
    ln -s $out/lib/ghidra/Ghidra/Framework/DB/lib/DB.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Docking/lib/Docking.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Help/lib/Help.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Gui/lib/Gui.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/Generic.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Utility/lib/Utility.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/guava-32.1.3-jre.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/failureaccess-1.0.1.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/jdom-legacy-1.1.3.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/log4j-core-2.17.1.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/log4j-api-2.17.1.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/commons-collections4-4.1.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/commons-compress-1.21.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/commons-text-1.10.0.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/commons-lang3-3.12.0.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/commons-io-2.11.0.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/gson-2.9.0.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/bcpkix-jdk15on-1.69.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/bcutil-jdk15on-1.69.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Generic/lib/bcprov-jdk15on-1.69.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Help/lib/timingframework-1.0.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Help/lib/javahelp-2.0.05.jar $out/share/java/
    ln -s $out/lib/ghidra/Ghidra/Framework/Gui/lib/flatlaf-3.5.4.jar $out/share/java/

    makeWrapper ${jdk}/bin/java $out/bin/ghidra-server \
      --add-flags "-cp $out/share/java/GhidraServer.jar ghidra.server.remote.GhidraServer \
      -Dghidra_home=${ghidra}/lib/ghidra"
  '';

  meta = {
    description = "Ghidra Server";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
