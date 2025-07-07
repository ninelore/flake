{ kdePackages, ... }:
kdePackages.kdeconnect-kde.overrideAttrs (prevPdAttrs: {
  src = builtins.fetchGit {
    url = "https://invent.kde.org/network/kdeconnect-kde.git";
    rev = "83ff7010e1373c427f5b491ab0d609849d3ae509";
  };
})
