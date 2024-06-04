{ ... }: {
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      defaultSession = "hyprland";
      autoLogin = {
        enable = true;
        user = "9l";
      };
    };
  };
}
