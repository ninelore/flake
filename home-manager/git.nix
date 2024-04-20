let
  email = "9l@9lo.re";
  name = "ninelore";
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
    };
    signing = {
      signByDefault = true;
      key = "794BE2582FB7A351";
    };
    userEmail = email;
    userName = name;
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.editor = editor;
  };
}
