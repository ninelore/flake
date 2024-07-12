{ inputs, pkgs, ... }:
let
  username = "9l";
  email = "9l@9lo.re";
  gituser = "ninelore";
  name = "Ingo Reitz";
  editor = "nvim";
in
{
  users.users.${username} = {
    shell = pkgs.nushell;
    isNormalUser = true;
    initialPassword = username;
    extraGroups = [
      "networkmanager"
      "power"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "docker"
      "adbusers"
      "plugdev"
      "openrazer"
      "wireshark"
    ];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      pkgs-bleeding = import inputs.nixpkgs-master {
        system = pkgs.system;
        config.allowUnfree = true;
      };
      pkgs-small = import inputs.nixpkgs-small {
        system = pkgs.system;
        config.allowUnfree = true;
      };
    };
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";

      imports = [ ./home-manager/home.nix ];

      programs.git = {
        enable = true;
        extraConfig = {
          color.ui = true;
          core.editor = editor;
          #credential.helper = "store";
          github.user = username;
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
    };
  };
  services.displayManager.autoLogin = {
    user = username;
  };
}
