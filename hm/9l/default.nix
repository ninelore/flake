{ ... }:
let
  email = "9l@9lo.re";
  gituser = "ninelore";
  name = "Ingo Reitz";
  editor = "nvim";
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = editor;
      #credential.helper = "store";
      github.user = gituser;
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
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
