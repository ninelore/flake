{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.pkgs-small.zed-editor;
  };
}
