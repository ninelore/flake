{
  cosmic-applets,
  fetchpatch2,
  ...
}:
cosmic-applets.overrideAttrs (oldAttrs: {
  patches = [
    (fetchpatch2 {
      name = "fix-bluetooth-dbus-spam.patch";
      url = "https://github.com/pop-os/cosmic-applets/commit/b6bb982f2dace0a3d19c78b4b4247760a8010d5b.patch?full_index=1";
      hash = "sha256-S5F9rqYrB38T9R6i/n/j3s79Xeh6BMmNkC+E2kTsus4=";
    })
    (fetchpatch2 {
      name = "fix-wifi-reconnect.patch";
      url = "https://github.com/pop-os/cosmic-applets/commit/114f849143a7115d7c9c6396f9aeb536427320d4.patch?full_index=1";
      hash = "sha256-J3+SRIE2LFUxPu2Mz6qto382yTEwdrkXzkaWzG9tR1c=";
    })
  ];
})
