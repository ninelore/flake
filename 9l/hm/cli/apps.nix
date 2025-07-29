{ pkgs, ... }:
let
  EDITOR = "nvim";
in
{
  home = {
    packages = with pkgs; [
      android-tools
      binwalk
      curl
      ddcutil
      dmidecode
      flyctl
      hexpatch
      pciutils
      picocom
      vboot_reference
      unzip
      usbutils
      zip
    ];
  };

  programs = {
    btop.enable = true;
    distrobox = {
      enable = true;
    };
    direnv.enable = true;
    fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./fastfetch.jsonc);
    };
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
        core.editor = EDITOR;
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
      settings.editor = EDITOR;
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
