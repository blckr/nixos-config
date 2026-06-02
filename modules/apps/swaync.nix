{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.apps.swaync;
  powerSettings =
    if (config.modules.powerManagement.profile == "ppd") then
      ''
        ,
              "menu#power-profiles": {
                "label": "󱐋",
                "position": "left",
                "actions": [
                  {
                    "label": "󰓅 Performance",
                    "command": "sh -c 'cpupower-gui -p && powerprofilesctl set performance'"
                  },
                  {
                    "label": "󰾅 Balanced",
                    "command": "sh -c 'cpupower-gui -p && powerprofilesctl set balanced'"
                  },
                  {
                    "label": "󰾆 Power-Saver",
                    "command": "sh -c 'cpupower-gui -b && powerprofilesctl set power-saver'"
                  }
                ]
              }
      ''
    else if (config.modules.powerManagement.profile == "tlp") then
      ''
        ,
              "menu#power-profiles": {
                "label": "󱐋",
                "position": "left",
                "actions": [
                  {
                    "label": "󰓅 Performance",
                    "command": "cpupower-gui -p"
                  },
                  {
                    "label": "󰾆 Power-Saver",
                    "command": "cpupower-gui -b"
                  }
                ]
              }
      ''
    else
      "";
in
{
  options.modules.apps.swaync = {
    enable = lib.mkEnableOption "sway-notificationcenter";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swaynotificationcenter
      wdisplays
      wofi
    ];

  services.cpupower-gui.enable = true;

  home-manager.users.${username} =
    { config, ... }:
    {
      xdg.configFile = {
        # Swaync JSON
        "swaync/config.json".text = ''
          {
            "$schema": "/etc/xdg/swaync/configSchema.json",
            "positionX": "right",
            "positionY": "top",
            "layer": "overlay",
            "control-center-layer": "top",
            "layer-shell": true,
            "cssPriority": "application",
            "control-center-width": 520,
            "control-center-margin-top": 0,
            "control-center-margin-bottom": 0,
            "control-center-margin-right": 0,
            "control-center-margin-left": 0,
            "notification-2fa-action": true,
            "notification-inline-replies": false,
            "notification-window-width": 380,
            "notification-icon-size": 48,
            "notification-body-image-height": 240,
            "notification-body-image-width": 240,
            "timeout": 8,
            "timeout-low": 4,
            "timeout-critical": 0,
            "fit-to-screen": true,
            "keyboard-shortcuts": true,
            "image-visibility": "when-available",
            "transition-time": 150,
            "hide-on-clear": true,
            "hide-on-action": true,
            "script-fail-notify": true,
            "widgets": [
              "mpris",
              "volume",
              "title",
              "notifications",
              "backlight",
              "buttons-grid"
            ],
            "widget-config": {
              "title": {
                "text": "Notifications",
                "clear-all-button": true,
                "button-text": "Clear"
              },
              "mpris": {
                "image-size": 80,
                "image-radius": 10
              },
              "volume": {
                "label": "",
                "step": 5
              },
              "backlight": {
                "label": "󰃞",
                "step": 5
              },
              "buttons-grid": {
                "actions": [
                  {
                    "label": "",
                    "command": "nm-connection-editor",
                    "tooltip": "Network"
                  },
                  {
                    "label": "",
                    "command": "blueman-manager",
                    "tooltip": "Bluetooth"
                  },
                  {
                    "label": "󰂛",
                    "command": "swaync-client -d",
                    "type": "toggle",
                    "tooltip": "DND"
                  },
                  {
                    "label": "",
                    "command": "systemctl suspend",
                    "tooltip": "Suspend"
                  },
                  {
                    "label": "",
                    "command": "hyprlock",
                    "tooltip": "Lock"
                  },
                  {
                    "label": "󰜉",
                    "command": "systemctl reboot",
                    "tooltip": "Reboot"
                  },
                  {
                    "label": "⏻",
                    "command": "systemctl poweroff",
                    "tooltip": "Power Off"
                  }
                ]
              }
            }
          }
        '';

        # Swaync CSS – Everforest Dark (Medium), 4px Abstand, 8px Radius
        "swaync/style.css".text = ''

          /* Gruvbox Colours ─────────────────────────────────────────── */    
          /*
          @define-color bg0                  #282828;
          @define-color bg1                  #3c3836;
          @define-color bg2                  #504945;
          @define-color bg3                  #665c54;
          @define-color fg0                  #fbf1c7;
          @define-color fg1                  #d5c4a1;
          @define-color fg2                  #d5c4a1;
          @define-color fg3                  #bdae93;
          @define-color gray                 #928374;
          @define-color red0                 #cc241d;
          @define-color red1                 #fb4934;
          @define-color green0               #98971a;
          @define-color green1               #b8bb26;
          @define-color yellow0              #d79921;
          @define-color yellow1              #fabd2f;
          @define-color blue0                #458588;
          @define-color blue1                #83a598;
          @define-color purple0              #b16286;
          @define-color purple1              #d3869b;
          @define-color aqua0                #689d6a;
          @define-color aqua1                #8ec07c;
          @define-color orange0              #d65d0e;
          @define-color orange1              #fe8019;
          */

          /* Central Theme Colours ───────────────────────────────────────── */
          @define-color bg0                  #${config.modules.theme.data.ui_colors.bg};
          @define-color bg1                  #${config.modules.theme.data.ui_colors.bg_alt};
          @define-color bg2                  #${config.modules.theme.data.ui_colors.bg_alt};
          @define-color bg3                  #${config.modules.theme.data.ui_colors.gray};
          @define-color fg0                  #${config.modules.theme.data.ui_colors.fg};
          @define-color fg1                  #${config.modules.theme.data.ui_colors.fg};
          @define-color fg2                  #${config.modules.theme.data.ui_colors.fg};
          @define-color fg3                  #${config.modules.theme.data.ui_colors.gray};
          @define-color gray                 #${config.modules.theme.data.ui_colors.gray};
          @define-color dark-gray            #${config.modules.theme.data.ui_colors.bg_alt};
          @define-color black                #${config.modules.theme.data.ui_colors.bg_alt};
          @define-color red0                 #${config.modules.theme.data.ui_colors.red};
          @define-color red1                 #${config.modules.theme.data.ui_colors.red};
          @define-color green0               #${config.modules.theme.data.ui_colors.green};
          @define-color green1               #${config.modules.theme.data.ui_colors.green};
          @define-color yellow0              #${config.modules.theme.data.ui_colors.yellow};
          @define-color yellow1              #${config.modules.theme.data.ui_colors.yellow};
          @define-color blue0                #${config.modules.theme.data.ui_colors.blue};
          @define-color blue1                #${config.modules.theme.data.ui_colors.blue};
          @define-color purple0              #${config.modules.theme.data.ui_colors.magenta};
          @define-color purple1              #${config.modules.theme.data.ui_colors.magenta};
          @define-color aqua0                #${config.modules.theme.data.ui_colors.cyan};
          @define-color aqua1                #${config.modules.theme.data.ui_colors.cyan};
          @define-color orange0              #${config.modules.theme.data.ui_colors.accent};
          @define-color orange1              #${config.modules.theme.data.ui_colors.accent};


          /* Palette ─────────────────────────────────────────────────── */
          @define-color theme_fg             @fg0;
          @define-color theme_fg_secondary   @fg1;
          @define-color theme_bg             @bg0;
          @define-color popup_bg             @bg0;
          @define-color module_bg            @bg1;
          @define-color module_hover_bg      @gray;
          @define-color button_bg            @bg1; /* Clear button */
          @define-color button_hover_bg      @orange0; /* Clear button hover */
          @define-color accent_color         @yellow0;
          @define-color accent_color_hover   @blue0;
          @define-color border_light         @border_medium; /* Uniform Bordering */
          @define-color border_dark          @border_medium;
          @define-color border_medium        @bg0;
          @define-color icon_primary         @theme_fg;
          @define-color icon_secondary       @yellow0;
          @define-color slider_trough_bg     @bg2; /* Background Sound-Slider */
          @define-color slider_thumb_bg      @fg0; /* Button Sound-Slider */
          @define-color close_button_bg      @gray;
          @define-color close_button_hover_bg@green0;
          @define-color mpris_player_bg      @bg1;

          /* Basis-Reset ────────────────────────────────────────────── */
          * {
            font-family: "Inter", "SF Pro Text", sans-serif;
            font-size: 17px;
            color: @theme_fg;
            border: none;
            border-radius: 0px;
            background: none;
            padding: 0;
            margin: 0;
            box-shadow: none;
            text-shadow: none;
            outline: none;
          }

          /* Control Center ─────────────────────────────────────────── */

          .control-center {
            margin: 4px;
            background-color: @theme_bg;
            border: 3px solid @border_medium;
            border-top-color: @border_light;
            border-bottom-color: @border_dark;
            border-radius: 0px;
            padding: 28px;
            min-width: 380px;
          }

          /* Widgets ───────────────────────────────────────────────── */

          .widget-mpris,
          .widget-volume,
          .widget-backlight,
          .widget-buttons-grid,
          .control-center-list > box > *:not(.widget-title) {
            background-color: @module_bg;
            border-radius: 0px;
            padding: 18px;
            margin-bottom: 14px;
            border: 1px solid @border_medium;
          }
          .widget-volume, .widget-backlight { padding: 14px 18px; }
          .widget-buttons-grid { padding: 12px; }
          .control-center > box > *:last-child { margin-bottom: 0; }

          /* Titel-Module ──────────────────────────────────────────── */

          .widget-title {
            background: none;
            border: none;
            padding: 4px 6px 12px;
            margin-bottom: 8px;
          }
          .widget-title label { font-weight: 500; color: @theme_fg_secondary; }
          .widget-title button {
            font-size: 16px;
            color: @theme_fg;
            background-color: @button_bg;
            border-radius: 8px;
            padding: 7px 16px;
            transition: background-color 0.15s ease;
          }
          .widget-title button:hover { background-color: @button_hover_bg; }

          /* MPRIS Widget ─────────────────────────────────────────── */

          .widget-mpris .widget-mpris-player {
            background-color: @mpris_player_bg;
            border-radius: 8px;
            border: 1px solid @border_medium;
            padding: 16px;
          }
          .widget-mpris .widget-mpris-album-art { border-radius: 8px; margin-right: 12px; }
          .widget-mpris .widget-mpris-title    { font-size: 20px; font-weight: 600; margin-bottom: 4px; }
          .widget-mpris .widget-mpris-subtitle { font-size: 16px; }
          .widget-mpris .widget-mpris-player button:hover {
            background-color: @button_hover_bg; color: @icon_primary;
          }
          .widget-mpris .widget-mpris-player button:disabled { color: @border_medium; }

          /* Slider (Volume, Backlight) ───────────────────────────── */

          .widget-volume label, .widget-backlight label { font-size: 24px; margin-right: 14px; }
          scale trough { min-height: 12px; border-radius: 6px; background-color: @slider_trough_bg; }
          scale trough progress { background-color: @accent_color; transition: background-color 0.15s ease; }
          scale:hover trough progress { background-color: @accent_color; }
          trough highlight {
            background: @accent_color; border-radius: 20px; box-shadow: 0 0 5px rgba(0,0,0,0.5);
          }
          scale slider { background-color: @slider_thumb_bg; border-radius: 7px; }

          /* Button Grid ──────────────────────────────────────────── */

          .widget-buttons-grid > flowboxchild > button {
            background-color: @module_bg; border-radius: 50%; padding: 14px; min-width: 24px; min-height: 24px;
            transition: background-color 0.15s ease;
          }
          .widget-buttons-grid > flowboxchild > button:hover { background-color: @button_hover_bg; }
          .widget-buttons-grid > flowboxchild > button.toggle:checked {
            background-color: @accent_color; color: white;
          }
          .widget-buttons-grid > flowboxchild > button.toggle:checked:hover {
            background-color: @accent_color_hover;
          }

          /* Notification Center & Floating ───────────────────────── */

          .control-center-list,
          .floating-notifications .notification-background {
            border-radius: 0px;
            background-color: @module_bg;
            border: 1px solid @border_medium;
            padding: 16px;
            margin: 4px;
          }

          .control-center .notification-row,
          .floating-notifications .notification-row { margin-bottom: 12px; }

          .control-center .notification-row:hover .notification-background,
          .floating-notifications .notification-row:hover .notification-background {
            background-color: @module_hover_bg;
          }

          .control-center .notification .summary,
          .floating-notifications .notification .summary {
            font-weight: 600; color: @theme_fg;
          }

          .control-center .notification .body,
          .floating-notifications .notification .body {
            color: @theme_fg_secondary;
          }

          .control-center .notification .time,
          .floating-notifications .notification .time {
            font-size: 15px; color: @icon_secondary;
          }

          .notification-row image {
            margin-right: 8px;
          }

          .close-button {
            background-color: @close_button_bg; border-radius: 50%; min-width: 24px; min-height: 24px;
            transition: background-color 0.15s ease;
          }
          .close-button:hover { background-color: @close_button_hover_bg; }
        '';
      };
    };
  };
}
