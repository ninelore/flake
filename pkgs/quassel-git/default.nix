{
  monolithic ? true, # build monolithic Quassel
  enableDaemon ? false, # build Quassel daemon
  client ? false, # build Quassel client
  tag ? "-qt6", # tag added to the package name
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
  libdbusmenu,
  qca,
  openldap,
}:

let
  buildClient = monolithic || client;
  buildCore = monolithic || enableDaemon;
in

assert monolithic -> !client && !enableDaemon;
assert client || enableDaemon -> !monolithic;

let
  edf = flag: feature: [ ("-D" + feature + (if flag then "=ON" else "=OFF")) ];

in
stdenv.mkDerivation {
  pname = "quassel${tag}";
  version = "0.14.0-unstable-2026-05-13";

  src = fetchFromGitHub {
    owner = "quassel";
    repo = "quassel";
    rev = "562ac3b5e4618275dbf8cfd0eefe89d36b484a46"; # currently a PR for Qt6
    sha256 = "sha256-e9WzkChH+b9r5qtF1I+rURgozifqQwo1JWX/Z+vRO/U=";
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
  ];

  cmakeFlags = [
    "-DEMBED_DATA=OFF"
  ]
  ++ edf static "STATIC"
  ++ edf monolithic "WANT_MONO"
  ++ edf enableDaemon "WANT_CORE"
  ++ edf enableDaemon "WITH_LDAP"
  ++ edf client "WANT_QTCLIENT";

  dontWrapQtApps = true;

  postFixup =
    lib.optionalString enableDaemon ''
      wrapProgram "$out/bin/quasselcore" --suffix PATH : "${qtbase}/bin"
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
