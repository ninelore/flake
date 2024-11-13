{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor_git;
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
