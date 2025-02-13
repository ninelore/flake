{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # cli
      android-tools
      btop
      cbfstool
      curl
      distrobox
      dmidecode
      fastfetch
      flyctl
      gnutar
      less
      lm_sensors
      nixfmt-rfc-style
      pciutils
      picocom
      tldr
      unar
      vboot_reference
      zip
      unzip
      usbutils
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
      gpg.enable = true;
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
          gnumake
          lua5_1
          luarocks
          ripgrep
          tree-sitter
          wget
          wl-clipboard
          # Mason  TODO: Bad Practice
          cargo
          go
          jdk17_headless
          python3
          rustc
          # Stuff that doesnt work or isnt available via mason.nvim
          nil
          nixd
          nixfmt-rfc-style
        ];
      };
    };

  services = {
    gpg-agent.enable = true;
  };
}
