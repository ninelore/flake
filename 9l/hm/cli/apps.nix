{ lib, pkgs, ... }:
let
  withExtraPackages =
    pkg: extraPackages:
    pkgs.runCommand "${pkg.name}-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      for exe in ${lib.getBin pkg}/bin/*; do
        makeWrapper $exe $out/bin/$(basename $exe) --prefix PATH : ${lib.makeBinPath extraPackages}
      done
    '';
in

{
  home = {
    packages = with pkgs; [
      android-tools
      btop
      ddcutil
      devenv
      distrobox
      fd
      flyctl
      fzf
      picocom
      tldr
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
      direnv.enable = true;
      git = {
        enable = true;
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
