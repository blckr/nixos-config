{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.apps.docker;
in
{
  options.modules.apps.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };

    users.users.${username}.extraGroups = [ "docker" ];
  };
}
