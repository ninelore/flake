{
  pkgs,
  ...
}:
{
  home.stateVersion = "24.05";

  imports = [
    ./9l.nix
    ./apps.nix
    ./nix-scripts.nix
    ./sh.nix
  ];

  services.gpg-agent.pinentry.package = pkgs.pinentry-all;

  programs = {
    home-manager.enable = true;
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };
      settings = {
        shell = "nu";
        wayland_titlebar_color = "background";
        remember_window_size = true;
        enabled_layouts = "tall:bias=50;full_size=1;mirrored=false,fat:bias=50;full_size=1;mirrored=false,stack";
        confirm_os_window_close = 0;
      };
      keybindings = {
        "ctrl+shift+tab" = "layout_action mirror toggle";
      };
      themeFile = "Monokai_Soda";
    };
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
