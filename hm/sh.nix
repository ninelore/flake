{ pkgs, ... }:
let
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
    "code" = "codium";
    ":q" = "exit";
    "q" = "exit";
  };
in
{
  programs = {
    zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        default_shell = "${pkgs.nushell}/bin/nu";
        theme = "dracula";
        ui = {
          pane_frames = {
            hide_session_name = true;
          };
        };
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
    };

    zsh = {
      inherit shellAliases;
      enable = true;
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

            ls.clickable_links = true;
            rm.always_trash = true;

            table = {
              index_mode = "always";
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
