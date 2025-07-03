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

  programs = {
    home-manager.enable = true;
    ghostty = {
      enable = true;
      settings = {
        command = "nu -i";
        font-family = "JetBrainsMono Nerd Font";
        font-style = "Medium";
        font-style-bold = "Bold";
        font-style-italic = "Medium Italic";
        font-style-bold-italic = "Bold Italic";
        font-size = 11;
        adjust-cell-height = 1;
        window-padding-balance = true;
        theme = "Monokai Remastered";
        cursor-color = "#FFFFFF";
        window-theme = "ghostty";
        adw-toolbar-style = "flat";
        gtk-titlebar-hide-when-maximized = true;
        mouse-scroll-multiplier = 0.3;
        keybind = "ctrl+,=unbind";
      };
    };
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
