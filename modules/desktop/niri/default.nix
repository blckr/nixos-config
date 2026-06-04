{ lib, config, ... }:
{
  options.modules.desktop.niri = {
    statusbar = lib.mkOption {
      type = lib.types.enum [ "waybar" "noctalia" ];
      default = "noctalia";
      description = "The status bar to use with Niri ('waybar' or 'noctalia').";
    };
  };

  imports = [
    ./niri.nix
    ./lightdm.nix
    ./waybar.nix
    ./noctalia.nix
    ./walker.nix
  ];
}
