{ ... }:
let
  editor = "hx";
in
{
  programs = {
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
    lazygit = {
      enable = true;
    };
  };
}
