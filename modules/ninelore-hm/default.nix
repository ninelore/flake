{ config, lib, ... }:
{
  options = {
    ninelore.cli = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to use ninelore's CLI home-manager configuration";
      type = lib.types.bool;
    };

    ninelore.gui = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to use ninelore's GUI home-manager configuration";
      type = lib.types.bool;
    };

    ninelore.extraApps = lib.mkOption {
      default = config.ninelore.gui;
      example = false;
      description = "Whether to enable additional GUI apps";
      type = lib.types.bool;
    };

  };

  config =
    lib.mkIf config.ninelore.cli {
      imports = [
        ./cli
      ];
    }
    // lib.mkIf config.ninelore.gui {
      assertions = [
        {
          assertion = config.ninelore.cli;
          message = "The gui config depends on the cli config";
        }
      ];
      imports = [
        ./gui
      ];
    }
    // lib.mkIf config.ninelore.extraApps {
      assertions = [
        {
          assertion = config.ninelore.gui;
          message = "The extraApps depend on the gui config";
        }
      ];
      imports = [
        ./gui/personal
      ];
    };
}
