{  ... }: let
  email = "9l@9lo.re";
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
      github.user = name;
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };
    signing = {
      signByDefault = true;
      key = "794BE2582FB7A351";
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
