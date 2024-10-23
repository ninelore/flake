{ ... }:
let
  email = "9l@9lo.re";
  gituser = "ninelore";
  name = "Ingo Reitz";
  editor = "hx";
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      commit.verbose = true;
      core.editor = editor;
      github.user = gituser;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
    signing = {
      signByDefault = true;
      key = "794BE2582FB7A351"; # TODO decouple from config somehow?
    };
    userEmail = email;
    userName = name;
    ignores = [
      "shell.nix"
      "*.session.sql"
    ];
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.editor = editor;
  };
}
