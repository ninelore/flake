{ pkgs, inputs }: {
  environment.systemPackages = with inputs.nix-alien.packages.${system}; [
    nix-alien
  ];
  # Optional, needed for `nix-alien-ld`
  programs.nix-ld.enable = true;
}
