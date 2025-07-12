{
  cosmic-applets,
  fetchpatch,
  ...
}:
cosmic-applets.overrideAttrs (oldAttrs: {
  patches = [
    (fetchpatch {
      url = "https://github.com/pop-os/cosmic-applets/commit/b6bb982f2dace0a3d19c78b4b4247760a8010d5b.patch";
      hash = "sha256-sVgHc0X0GLwNxI8CBcuJCsK5+h0WAXnMZoZkqzKyO1c=";
    })
  ];
})
