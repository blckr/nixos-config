{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.apps.ausweisapp;
in
{
  options.modules.apps.ausweisapp = {
    enable = lib.mkEnableOption "ausweisapp";
  };

  config = lib.mkIf cfg.enable {
    programs.ausweisapp.enable = true;
    programs.ausweisapp.openFirewall = true;
  };
}
