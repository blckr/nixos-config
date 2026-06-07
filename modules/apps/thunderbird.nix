{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.modules.apps.thunderbird;

  thunderbird-gnome-theme = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "thunderbird-gnome-theme";
    rev = "c61b897554b5631c042c5e3c4b76cc021a9890b7";
    hash = "sha256-BB0V/tvTBEPIpS+UKzQUUjQIRuHxLVAxF+anZW4vH5c=";
  };
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
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "svg.context-properties.content.enabled" = true;
          };
          userChrome = ''
            @import "thunderbird-gnome-theme/userChrome.css";
            @import "noctalia-colors.css";
          '';
          userContent = ''
            @import "thunderbird-gnome-theme/userContent.css";
            @import "noctalia-colors.css";
          '';
        };
      };

      home.file = {
        ".thunderbird/default/chrome/thunderbird-gnome-theme" = {
          source = thunderbird-gnome-theme;
          recursive = true;
        };
      };
    };
  };
}
