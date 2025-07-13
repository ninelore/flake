# TODO: remove?

{ ... }:
let
  email = "9l@9lo.re";
  ghName = "ninelore";
  name = "Ingo Reitz";
in
{
  programs.git = {
    extraConfig = {
      github.user = ghName;
    };
    signing = {
      signByDefault = true;
      key = "794BE2582FB7A351"; # TODO decouple from config somehow?
    };
    userEmail = email;
    userName = name;
  };
}
