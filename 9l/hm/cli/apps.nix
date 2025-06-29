{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      android-tools
      ddcutil
      flyctl
      picocom
      vboot_reference
      zip
      unzip
      weechat
    ];
  };

  programs =
    let
      editor = "nvim";
    in
    {
      btop.enable = true;
      distrobox = {
        enable = true;
        # TODO: Declare containers?
      };
      direnv.enable = true;
      fd = {
        enable = true;
        hidden = true;
        ignores = [
          ".git/"
        ];
      };
      fzf.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
        extraConfig = {
          color.ui = true;
          commit.verbose = true;
          core.editor = editor;
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.rebase = true;
        };
        ignores = [
          "*.session.sql"
        ];
      };
      gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings.editor = editor;
      };
      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
        withPython3 = true;
        extraPackages = with pkgs; [
          fd
          gcc
          git
          lua5_1
          luarocks
          ripgrep
          tree-sitter
          wget
          wl-clipboard
          # Always have these available
          bash-language-server
          lua-language-server
          nil
          nixd
          nixfmt-rfc-style
          nushell
          shellcheck
          stylua
          typescript-language-server
          vscode-langservers-extracted
          yaml-language-server
        ];
      };
    };
}
