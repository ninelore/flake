{
  monolithic ? true, # build monolithic Quassel
  enableDaemon ? false, # build Quassel daemon
  client ? false, # build Quassel client
  tag ? "-kf6", # tag added to the package name
  static ? false, # link statically

  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  wrapQtAppsHook,
  dconf,
  qtbase,
  boost,
  zlib,
  qt5compat,
  qtwebengine,
  phonon,
  libdbusmenu,
  qca,
  openldap,

  withKDE ? true, # enable KDE integration
  extra-cmake-modules,
  kconfigwidgets,
  kcoreaddons,
  knotifications,
  knotifyconfig,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
}:

let
  buildClient = monolithic || client;
  buildCore = monolithic || enableDaemon;
in

assert monolithic -> !client && !enableDaemon;
assert client || enableDaemon -> !monolithic;
assert !buildClient -> !withKDE; # KDE is used by the client only

let
  edf = flag: feature: [ ("-D" + feature + (if flag then "=ON" else "=OFF")) ];

in
stdenv.mkDerivation {
  pname = "quassel${tag}";
  version = "0.14.0-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "quassel";
    repo = "quassel";
    rev = "31d0daa4301ee2af74bfc7fa0955ea0a8b3c31d6"; # currently a PR for Qt6
    sha256 = "sha256-m3lMRzNA5B8gwUcao5T9xwPH1AhZTSrtG2NuGd5DyGc=";
  };

  # Prevent ``undefined reference to `qt_version_tag''' in SSL check
  env.NIX_CFLAGS_COMPILE = "-DQT_NO_VERSION_TAGGING=1";

  nativeBuildInputs = [
    cmake
    makeWrapper
  ]
  ++ lib.optional buildClient wrapQtAppsHook;
  buildInputs = [
    qtbase
    qt5compat
    boost
    zlib
  ]
  ++ lib.optionals buildCore [
    qca
    openldap
  ]
  ++ lib.optionals buildClient [
    qtwebengine
    libdbusmenu
    phonon
  ]
  ++ lib.optionals (buildClient && withKDE) [
    extra-cmake-modules
    kconfigwidgets
    kcoreaddons
    knotifications
    knotifyconfig
    ktextwidgets
    kwidgetsaddons
    kxmlgui
  ];

  cmakeFlags = [
    "-DEMBED_DATA=OFF"
  ]
  ++ edf static "STATIC"
  ++ edf monolithic "WANT_MONO"
  ++ edf enableDaemon "WANT_CORE"
  ++ edf enableDaemon "WITH_LDAP"
  ++ edf client "WANT_QTCLIENT"
  ++ edf withKDE "WITH_KDE";

  dontWrapQtApps = true;

  postFixup =
    lib.optionalString enableDaemon ''
      wrapProgram "$out/bin/quasselcore" --suffix PATH : "${qtbase.bin}/bin"
    ''
    + lib.optionalString buildClient ''
      wrapQtApp "$out/bin/quassel${lib.optionalString client "client"}" \
        --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
    '';

  meta = {
    homepage = "https://quassel-irc.org/";
    description = "Qt/KDE distributed IRC client supporting a remote daemon";
    longDescription = ''
      Quassel IRC is a cross-platform, distributed IRC client,
      meaning that one (or multiple) client(s) can attach to
      and detach from a central core -- much like the popular
      combination of screen and a text-based IRC client such
      as WeeChat, but graphical (based on Qt4/KDE4 or Qt5/KF5).
    '';
    license = lib.licenses.gpl3;
    mainProgram =
      if monolithic then
        "quassel"
      else if buildClient then
        "quasselclient"
      else
        "quasselcore";
    # inherit (qtbase.meta) platforms;
    platforms = lib.platforms.linux;
  };
}
