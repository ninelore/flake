{ kdePackages, ... }:
kdePackages.kdeconnect-kde.overrideAttrs (prevPdAttrs: {
  version = "25.07.80-unstable-2025-07-14";
  src = builtins.fetchGit {
    url = "https://invent.kde.org/network/kdeconnect-kde.git";
    rev = "4ab87318e7589d2d1d28a0c0c43936407b636cdd";
  };
})
