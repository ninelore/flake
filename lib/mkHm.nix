{
  # Extra homeModules
  extraModules ? [ ],

  # Username
  username,

  inputs,
  ...
}:
let
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib // inputs.self.lib;
in
{
  ${username} = lib.homeManagerConfiguration {
    extraSpecialArgs = { inherit inputs; };
    modules = [
      inputs.self.homeModules.default
      inputs.self.homeModules.ninelore
      inputs.chaotic.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
      {
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
        };
        targets.genericLinux.enable = true;
        nixGL = {
          packages = inputs.nixgl.packages;
          installScripts = [
            "mesa"
            "mesaPrime"
            "nvidiaPrime"
          ];
        };
        programs = {
          nix-index-database.comma.enable = true;
        };
      }
    ] ++ extraModules;
  };
}
