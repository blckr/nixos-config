{ config, lib, ... }:
{
  options.modules.apps.thunderbird.enable = lib.mkEnableOption "thunderbird";

  config = lib.mkIf config.modules.apps.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings."extensions.activeThemeID" = "default-theme@mozilla.org";
      };
    };
  };
}
