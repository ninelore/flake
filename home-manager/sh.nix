{ pkgs
, lib
, ...
}:
let
  shellAliases = {
    "db" = "distrobox";
    "untar" = "tar -xavf";
    "v" = "nvim";
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
    oh-my-posh = {
      enable = false;
      useTheme = "json";
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        scan_timeout = 10;
        command_timeout = 10;
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
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = ''"${pkgs.nushell}/bin/nu"'';
      };
      extraConfig =
        let
          theme = "molokai";

          conf = builtins.toJSON {
            show_banner = false;
            edit_mode = "vi";
            shell_integration = true;

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
            names:
            builtins.foldl'
              (prev: str: "${prev}\n${str}") ""
              (map (name: completion name) names);
        in
        ''
          use ${pkgs.nu_scripts}/share/nu_scripts/themes/nu-themes/${theme}.nu;
          $env.config = ${conf};
          $env.config.color_config = (${theme});
          ${completions ["cargo" "git" "nix" "npm"]}
        '';
    };
  };
}
