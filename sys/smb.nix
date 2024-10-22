{ ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "10.10. 192.168.156. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
      };
      "private" = {
        "path" = "/srv/smbshare";
        "guest ok" = "no";
        "guest only" = "no";
        "write list" = "@ninelsmb";
        "valid users" = "@ninelsmb";
        "force group" = "ninelsmb";
      };
    };
  };
  users.groups.ninelsmb = {};
  system.activationScripts = {
    smbshareFolder.text = ''
      mkdir -p /srv/smbshare
      chown -R root:ninelsmb /srv/smbshare
      chmod -R g+rw /srv/smbshare
    '';
  };
}
