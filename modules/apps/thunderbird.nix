{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.apps.thunderbird;
in
{
  options.modules.apps.thunderbird = {
    enable = lib.mkEnableOption "thunderbird";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.thunderbird = {
        enable = true;
        profiles.default = {
          isDefault = true;
          # Eingebautes System-Theme: übernimmt die GTK-Farben (Nordic)
          settings."extensions.activeThemeID" = "default-theme@mozilla.org";
        };
      };
    };
  };
}
