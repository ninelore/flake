{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor_git;
    extraPackages = (import ../../lib/lsp-dap.nix { pkgs = pkgs; });
    userSettings = {
      theme = "Zedokai";
      telemetry = {
        "diagnostics" = false;
        "metrics" = false;
      };
      "base_keymap" = "VSCode";
      "assistant" = {
        "version" = "2";
        "default_model" = {
          "provider" = "ollama";
          "model" = "qwen2.5-coder:1.5b";
        };
      };
      "buffer_font_family" = "JetBrainsMono Nerd Font Propo";
      "buffer_font_size" = 14;
      "languages" = {
        "Nix" = {
          "language_servers" = [
            "nixd"
            "!nil"
            "..."
          ];
        };
      };
      "lsp" = {
        "nixd" = {
          "initialization_options" = {
            "formatting" = {
              "command" = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
          };
        };
      };
    };
    extensions = [
      "cargo-tom"
      "devicetree"
      "docker-compose"
      "dockerfile"
      "ini"
      "java"
      "kdl"
      "latex"
      "log"
      "make"
      "markdown-oxide"
      "marksman"
      "mermaid"
      "meson"
      "nginx"
      "nix"
      "nu"
      "scss"
      "sql"
      "zedokai"
    ];
  };
}
