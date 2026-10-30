{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.apps.mullvad;
in
{
  options.modules.apps.mullvad = {
    enable = lib.mkEnableOption "mullvad-vpn";
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;
  };
}
