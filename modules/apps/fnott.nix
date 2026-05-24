{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.apps.fnott;
  # Ayu Mirage Colors
  colors = {
    bg = "212733";
    fg = "d9d7ce";
    accent = "ffad66";
    red = "f28779";
    blue = "73d0ff";
    green = "d5ff80";
  };
in
{
  options.modules.apps.fnott = {
    enable = lib.mkEnableOption "fnott notification daemon";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        fnott
        libnotify
        papirus-icon-theme
        mpv
        sound-theme-freedesktop
        (pkgs.writeShellScriptBin "fnott-toggle-dnd" ''
          STATE_FILE="$HOME/.cache/fnott-paused"
          if [ -f "$STATE_FILE" ]; then
            ${pkgs.fnott}/bin/fnottctl unpause
            rm "$STATE_FILE"
          else
            ${pkgs.fnott}/bin/fnottctl pause
            touch "$STATE_FILE"
          fi
        '')
      ];

      services.fnott = {
        enable = true;
        settings = {
          main = {
            anchor = "top-right";
            stacking-order = "top-down";
            min-width = 500;
            max-width = 500;
            edge-margin-vertical = 12;
            layer = "top";
            edge-margin-horizontal = 20;
            notification-margin = 8;
            icon-theme = "Papirus";
            max-icon-size = 48;
            selection-helper = "fuzzel -d";
            play-sound = "sh -c '${pkgs.mpv}/bin/mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message.oga'";

            background = "${colors.bg}ff";
            border-color = "${colors.accent}ff";
            border-size = 2;
            padding-vertical = 12;
            padding-horizontal = 12;
            title-font = "JetBrainsMono Nerd Font:size=12";
            title-color = "${colors.fg}ff";
            summary-font = "JetBrainsMono Nerd Font:bold:size=11";
            summary-color = "${colors.fg}ff";
            body-font = "JetBrainsMono Nerd Font:size=11";
            body-color = "${colors.fg}ff";
            border-radius = 4;

            # Persistent notifications
            default-timeout = 0;
            max-timeout = 0;
          };

          low = {
            background = "${colors.bg}ff";
            border-color = "${colors.blue}ff";
            default-timeout = 8;
          };

          normal = {
            default-timeout = 40;
          };

          critical = {
            background = "${colors.bg}ff";
            border-color = "${colors.red}ff";
            default-timeout = 0;
          };
        };
      };

    };
  };
}
