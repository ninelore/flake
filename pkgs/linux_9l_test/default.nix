{
  linux_latest,
  lib,
  ...
}:
linux_latest.override {
  structuredExtraConfig = with lib.kernel; {
    MTK_CMDQ = yes;
    MTK_MMSYS = yes;
    DRM_MEDIATEK = yes;
  };

  extraMeta = {
    platforms = lib.mkForce [ "aarch64-linux" ];
  };
}
