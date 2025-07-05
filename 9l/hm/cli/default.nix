{ ... }:
{
  home.stateVersion = "24.05";

  imports = [
    ./9l.nix
    ./apps.nix
    ./scripts
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
        keybind = [
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+,=reload_config"
          "ctrl+shift+enter=new_split:right"
          "ctrl+shift+o=new_split:down"
          "ctrl+shift+t=new_tab"
          "ctrl+shift+equal=increase_font_size:1"
          "ctrl+shift+plus=increase_font_size:1"
          "ctrl+shift+minus=decrease_font_size:1"
          "ctrl+shift+backspace=reset_font_size"
          "ctrl+shift+w=close_tab"
          "ctrl+shift+p=toggle_command_palette"
          "ctrl+shift+arrow_down=goto_split:down"
          "ctrl+shift+arrow_left=goto_split:left"
          "ctrl+shift+arrow_right=goto_split:right"
          "ctrl+shift+arrow_up=goto_split:up"
          "ctrl+shift+tab=next_tab"
        ];
      };
      clearDefaultKeybinds = true;
    };
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
