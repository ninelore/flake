{ pkgs, ... }:
let
  weztermConf = ''
    local wezterm = require 'wezterm'
    local config = {}
    config.font = wezterm.font 'JetBrainsMono Nerd Font Propo'
    config.color_scheme = 'Batman'
    return config
  '';

  shellAliases = {
    "db" = "distrobox";
    "untar" = "tar -xavf";
    "v" = "nvim";
    "vim" = "nvim";
    "ll" = "ls -a";
    "l" = "ls";
    "l." = "ls -d .*";
    "sv" = "sudo nvim";
    "r" = "ranger";
    "sr" = "sudo ranger";
    "c" = "clear";
    "crypo" = "sudo cryptsetup open";
    "crypc" = "sudo cryptsetup close";
    "py" = "python3";
    "grep" = "grep --color=auto";

    ":q" = "exit";
    "q" = "exit";
  };
in
{
  programs = {
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font Propo";
      };
      settings = {
        #"window_padding_width" = 4;
        "window_margin_width" = 4;
        "confirm_os_window_close" = 0;
        "background_opacity" = "0.8";
      };
    };

    carapace.enable = true;

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        scan_timeout = 2000;
        command_timeout = 2000;
      };
    };

    bash = {
      inherit shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
    };

    nushell = {
      inherit shellAliases;
      enable = true;
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = ''""'';
        PROMPT_INDICATOR_VI_NORMAL = ''""'';
      };
      extraConfig =
        let
          theme = "molokai";

          conf = builtins.toJSON {
            show_banner = false;
            edit_mode = "vi";
            #shell_integration = true; # boolean deprecated at 0.94

            ls.clickable_links = true;
            rm.always_trash = true;

            table = {
              index_mode = "always"; # always never auto
              header_on_separator = false;
            };

            cursor_shape = {
              vi_insert = "line";
              vi_normal = "block";
            };

            completions = {
              quick = true;
              partial = true;
              algorithm = "fuzzy";
              external = {
                enable = true;
                max_results = 100;
              };
            };

            menus = [
              {
                name = "completion_menu";
                only_buffer_difference = false;
                marker = "";
                type = {
                  layout = "columnar"; # list, description
                  columns = 4;
                  col_padding = 2;
                };
                style = {
                  text = "magenta";
                  selected_text = "blue_reverse";
                  description_text = "yellow";
                };
              }
            ];
          };
          completions =
            let
              completion = name: ''
                source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
              '';
            in
            names: builtins.foldl' (prev: str: "${prev}\n${str}") "" (map (name: completion name) names);
        in
        ''
          use ${pkgs.nu_scripts}/share/nu_scripts/themes/nu-themes/${theme}.nu;
          $env.config = ${conf};
          $env.config.color_config = (${theme});
          ${completions [
            "adb"
            "cargo"
            "curl"
            "docker"
            "fastboot"
            "gh"
            "git"
            "less"
            "make"
            "man"
            "mvn"
            "nix"
            "npm"
            "tar"
          ]}
        '';
    };
  };
}
