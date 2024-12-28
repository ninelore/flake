{ ... }:
{
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
      animeConfig = ''
        (
          model_override: None,
          system: [],
          boot: [],
          wake: [],
          shutdown: [],
          display_enabled: false,
          display_brightness: High,
          builtin_anims_enabled: false,
          off_when_unplugged: false,
          off_when_suspended: false,
          off_when_lid_closed: false,
          brightness_on_battery: Low,
          builtin_anims: (
            boot: GlitchConstruction,
            awake: RogLogoGlitch,
            sleep: Starfield,
            shutdown: GlitchOut,
          ),
        )
      '';
    };
    supergfxd.enable = true;
  };
}
