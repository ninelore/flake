{
  cosmic-applets,
  fetchpatch2,
  ...
}:
cosmic-applets.overrideAttrs (oldAttrs: {
  patches = [
    (fetchpatch2 {
      name = "fix-wifi-reconnect.patch";
      url = "https://github.com/pop-os/cosmic-applets/commit/114f849143a7115d7c9c6396f9aeb536427320d4.patch?full_index=1";
      hash = "sha256-J3+SRIE2LFUxPu2Mz6qto382yTEwdrkXzkaWzG9tR1c=";
    })
  ];
})
