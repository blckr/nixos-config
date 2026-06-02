{ lib, config, pkgs, ... }:
let
  cfg = config.modules.theme;
in
{
  options.modules.theme = {
    active = lib.mkOption {
      type = lib.types.str;
      default = "nord";
      description = "The name of the active theme (corresponds to a file in modules/core/themes/)";
    };
    
    # This will hold the actual theme data
    data = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      readOnly = true;
      description = "The data of the currently active theme";
    };
  };

  config = {
    modules.theme.data = import ./themes/${cfg.active}.nix { inherit pkgs; };
    
    environment.systemPackages = [
      cfg.data.gtk.package
      cfg.data.gtk.iconPackage
    ];
  };
}
