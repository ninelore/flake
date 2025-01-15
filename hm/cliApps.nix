{ pkgs, ... }:
{
  home = {
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/chromium-dev/depot_tools"
      "$HOME/go/bin"
    ];
    packages = with pkgs; [
      # cli
      android-tools
      btop
      chafa
      coreboot-utils
      curl
      distrobox
      dmidecode
      fastfetch
      flyctl
      gnutar
      gptfdisk
      less
      nixfmt-rfc-style
      pciutils
      picocom
      platformio-core
      starship # Distrobox fix
      tldr
      unar
      vboot_reference
      zip
      unzip
      usbutils
      weechat
    ];
  };

  programs = {
    broot.enable = true;
    direnv.enable = true;
    gpg.enable = true;
    jq.enable = true;
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
        # Stuff that doesnt work or isnt available via mason.nvim
        nil
        nixd
        nixfmt-rfc-style
      ];
    };
  };
}
