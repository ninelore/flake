{ pkgs, ... }:
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
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
        size = 11;
      };
      settings = {
        shell = "nu";
        wayland_titlebar_color = "background";
        remember_window_size = true;
        enabled_layouts = "splits:split_axis=horizontal";
        # Keymap
        clear_all_shortcuts = "yes";
        kitty_mod = "ctrl+shift";
        # https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/kitty/Monokai%20Remastered.conf
        color0 = "#1a1a1a";
        color1 = "#f4005f";
        color2 = "#98e024";
        color3 = "#fd971f";
        color4 = "#9d65ff";
        color5 = "#f4005f";
        color6 = "#58d1eb";
        color7 = "#c4c5b5";
        color8 = "#625e4c";
        color9 = "#f4005f";
        color10 = "#98e024";
        color11 = "#e0d561";
        color12 = "#9d65ff";
        color13 = "#f4005f";
        color14 = "#58d1eb";
        color15 = "#f6f6ef";
        background = "#0c0c0c";
        selection_foreground = "#0c0c0c";
        cursor = "#ffffff";
        cursor_text_color = "#000000";
        foreground = "#d9d9d9";
        selection_background = "#d9d9d9";
      };
      keybindings = {
        "kitty_mod+c" = "copy_to_clipboard";
        "kitty_mod+v" = "paste_from_clipboard";
        "kitty_mod+enter" = "launch --location=split --cwd=current";
        "kitty_mod+t" = "launch --type=tab --cwd=current";
        "kitty_mod+equal" = "change_font_size all +2.0";
        "kitty_mod+plus" = "change_font_size all +2.0";
        "kitty_mod+minus" = "change_font_size all -2.0";
        "kitty_mod+backspace" = "change_font_size all 0";
        "kitty_mod+w" = "close_window";
        "kitty_mod+b" = "detach_window new-tab";
        "kitty_mod+r" = "start_resizing_window";
        "kitty_mod+u" = "layout_action rotate";
        "kitty_mod+down" = "neighboring_window bottom";
        "kitty_mod+left" = "neighboring_window left";
        "kitty_mod+right" = "neighboring_window right";
        "kitty_mod+up" = "neighboring_window top";
        "kitty_mod+alt+down" = "move_window bottom";
        "kitty_mod+alt+left" = "move_window left";
        "kitty_mod+alt+right" = "move_window right";
        "kitty_mod+alt+up" = "move_window top";
        "kitty_mod+j" = "neighboring_window bottom";
        "kitty_mod+h" = "neighboring_window left";
        "kitty_mod+l" = "neighboring_window right";
        "kitty_mod+k" = "neighboring_window top";
        "kitty_mod+alt+j" = "move_window bottom";
        "kitty_mod+alt+h" = "move_window left";
        "kitty_mod+alt+l" = "move_window right";
        "kitty_mod+alt+k" = "move_window top";
        "kitty_mod+tab" = "next_tab";
        "kitty_mod+o" = "move_tab_backward";
        "kitty_mod+p" = "move_tab_forward";
        "kitty_mod+," = "previous_tab";
        "kitty_mod+." = "next_tab";
        "kitty_mod+page_up" = "scroll_page_up";
        "kitty_mod+page_down" = "scroll_page_down";
        "kitty_mod+home" = "scroll_home";
        "kitty_mod+end" = "scroll_end";
      };
    };
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
