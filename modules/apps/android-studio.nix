{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.modules.apps.android-studio;
in
{
  options.modules.apps.android-studio = {
    enable = lib.mkEnableOption "android-studio";
  };

  config = lib.mkIf cfg.enable {
    users.users.${username} = {
      packages = [ pkgs.android-studio ];
      extraGroups = [
        "kvm"
        # "adbusers"
      ];
    };

    # programs.adb.enable = true;
  };
}
