{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.modules.apps.wireshark;
in
{
  options.modules.apps.wireshark = {
    enable = lib.mkEnableOption "wireshark";
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark.enable = true;
    users.users.${username}.extraGroups = [ "wireshark" ];
  };
}
