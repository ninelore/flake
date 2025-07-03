{ lib, pkgs, ... }:
let
  shellAliases = {
    "c" = "clear";
    "db" = "distrobox";
    "grep" = "grep --color=auto";
    "py" = "python3";
    "q" = "exit";
    "untar" = "tar -xavf";
    "v" = "nvim";
    "z" = "zellij";
  };
in
{
  xdg.configFile = {
    "zellij".source = ./zellij;
  };
  programs = {
    zellij = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };

    starship = {
      enable = true;
      settings = {
        scan_timeout = 2000;
        command_timeout = 2000;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    bash = {
      inherit shellAliases;
      enable = true;
    };
    nushell = {
      inherit shellAliases;
      enable = true;
      environmentVariables = {
        TRANSIENT_PROMPT_COMMAND = lib.hm.nushell.mkNushellInline ''
          {||
            echo "\n" ((
              ^${pkgs.starship}/bin/starship prompt
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
            ) | lines | last) | str join
          }
        '';
        PROMPT_INDICATOR_VI_INSERT = "";
        PROMPT_INDICATOR_VI_NORMAL = "";
      };
      extraConfig =
        let
          theme = "monokai-soda";

          conf = builtins.toJSON {
            show_banner = false;
            edit_mode = "vi";
            ls.clickable_links = true;
            use_kitty_protocol = true;

            history = {
              file_format = "sqlite";
              max_size = 1000000;
              isolation = true;
            };

            cursor_shape = {
              vi_insert = "line";
              vi_normal = "block";
            };

            datetime_format.normal = "%y-%m-%d %I:%M:%S%p";
            filesize.precision = 2;

            table = {
              index_mode = "always";
              header_on_separator = false;
            };

            completions = {
              quick = true;
              partial = true;
              algorithm = "fuzzy";
              use_ls_colors = true;
              external = {
                enable = true;
                max_results = 50;
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
            "cargo"
            "curl"
            "gh"
            "git"
            "less"
            "make"
            "nix"
            "rg"
            "ssh"
            "tar"
            "zellij"
            "zoxide"
          ]}
        '';
    };
  };
}
