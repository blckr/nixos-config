{
  config,
  lib,
  pkgs,
  hostname,
  settings,
  ...
}:
let
  cfg = config.modules.kit;
in
{
  options.modules.kit = {
    flake = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Git/code-blckr/nixos-config";
      description = "Pfad zu diesem Repo auf dem Rechner";
    };
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      description = "Das gebaute kit-Skript";
    };
  };

  config = {
    modules.kit.package = import ./package.nix {
      inherit pkgs lib;
      platform = if pkgs.stdenv.isDarwin then "darwin" else "linux";
      host = hostname;
      user = config.home.username;
      inherit (cfg) flake;
      keys = import ./keys.nix { inherit lib config; };
      inherit (settings) theme;
      themes = lib.attrNames (import ../../themes.nix { inherit pkgs; });
    };
    home.packages = [ cfg.package ];
  };
}
