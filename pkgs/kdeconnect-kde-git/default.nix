{ kdePackages, ... }:
kdePackages.kdeconnect-kde.overrideAttrs (prevPdAttrs: {
  version = "25.07.90";
  src = builtins.fetchGit {
    url = "https://invent.kde.org/network/kdeconnect-kde.git";
    rev = "6df6cab16ef2ea364424f0f763612992d96f0a07";
  };
})
