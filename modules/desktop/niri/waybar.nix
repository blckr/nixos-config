# This module configures the waybar, a program to provide a very customizable taskbar.
# https://github.com/Alexays/Waybar/wiki
{
  config,
  lib,
  pkgs,
  username,
  ...
}:
lib.mkIf config.modules.desktop.enable (
  let
    themeData = config.modules.theme.data;
    ppdEnabled = config.modules.powerManagement.profile == "ppd";
    fnottEnabled = config.modules.apps.fnott.enable == true;
    waybarSettings = [
      {
        # General configurations
        "spacing" = 4;
        "layer" = "top";
        "position" = "bottom";
        "margin-top" = 0;
        "margin-bottom" = 0;
        "margin-left" = 0;
        "margin-right" = 0;
        "radius" = 0;
        "height" = 26;

        # Provides where and in what ordner the parts shall be ordered
        "modules-left" = [
          "niri/workspaces"
          "mpris"
        ];
        "modules-center" = [
          "niri/window"
        ];

        "modules-right" = [
          "custom/microphone"
          "custom/camera"
          "idle_inhibitor"
        ]
        ++ lib.optionals ppdEnabled [
          "power-profiles-daemon"
        ]
        ++ [
          "cpu"
          "memory"
          "bluetooth"
          "pulseaudio"
          "custom/vpn"
          "network"
        ]
        ++ lib.optionals fnottEnabled [
          "custom/notifications"
        ]
        ++ [
          "battery"
          "clock"
        ];

        ################ Left ################
        "niri/workspaces" = {
          "on-click" = "activate";
          "all-outputs" = false;
          "active-only" = true;
          "format" = "{icon}";
          "format-icons" = {
            "default" = "";
            "active" = "";
          };
        };
        "mpris" = {
          "format" = "{player_icon} {title} - {artist}";
          "format-paused" = "{status_icon} {title} - {artist}";

          "player-icons" = {
            "default" = "󰝚";
            "spotify" = "󰓇";
            "firefox" = "󰗃";
          };
          "status-icons" = {
            "paused" = "󰏤";
          };

          "tooltip-format" = "Playing: {title} - {artist}";
          "tooltip-format-paused" = "Paused: {title} - {artist}";
          "min-length" = 5;
          "max-length" = 35;

          "on-click" = "playerctl play-pause";
          "on-click-right" = "playerctl next";
        };

        ################ Center ################
        "niri/window" = {
          "tooltip" = false;
        };

        ################ Right #################

        "cpu" = {
          "interval" = 10;
          # "format" = " {usage}%";
          "format" = "";
          "states" = {
            "warning" = 50;
            "critical" = 80;
          };
        };
        "memory" = {
          "interval" = 10;
          # "format" = " {used}GiB";
          "format" = "";
          "states" = {
            "warning" = 70;
            "critical" = 90;
          };
        };
        "pulseaudio" = {
          # "format" = "{icon} {volume}%";
          "format" = "{icon}";
          "format-muted" = "";
          "format-icons" = {
            "bluetooth" = "󰋋";
            "headphones" = "󰋋";
            "phone" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pwvucontrol";
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "󰛨";
            "deactivated" = "󰌶";
          };
          "start-activated" = false;
        };
        "bluetooth" = {
          "format" = "{icon}";
          "format-icons" = {
            "connected" = "󰂯";
            "on" = "󰂯";
            "off" = "󰂲";
            "disabled" = "󰂲";
            "powered-off" = "󰂲";
            "disconnected" = "󰂲";
            "default" = "󰂲";
          };
          "tooltip" = true;
          "tooltip-format" = "{device_alias} ({device_address})";
          "on-click" = "blueman-manager";
        };
        "custom/microphone" = {
          "exec" = "$HOME/.config/waybar/microphone-usage.sh";
          "return-type" = "json";
          "interval" = 3;
          "format" = "{}";
          "tooltip" = true;
        };
        "custom/camera" = {
          "exec" = "$HOME/.config/waybar/camera-usage.sh";
          "return-type" = "json";
          "interval" = 3;
          "format" = "{}";
          "tooltip" = true;
        };
        "custom/vpn" = {
          "format" = "{text}";
          "exec" = "$HOME/.config/waybar/vpn-active.sh";
          "return-type" = "json";
          "interval" = 3;
          # "format-icons" = [
          #   ""
          #   ""
          # ];
          "on-click" = "nm-connection-editor";
        };
        "network" = {
          # "format-wifi" = "{icon} {bandwidthDownBytes}  {bandwidthUpBytes}  ";
          "format-wifi" = "{icon}";
          "format-ethernet" = "󰈀 ";
          "format-disconnected" = "󰖪";
          "format-icons" = {
            "wifi" = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
          };
          "tooltip" = true;
          "tooltip-format-wifi" = "{essid} ({signalStrength}%)\n{ipaddr}";
          "tooltip-format-ethernet" = "{ifname}\n{ipaddr}";
          "tooltip-format-disconnected" = "Nicht verbunden";
          "on-click" = "nm-connection-editor";
        };
        "battery" = {
          "format" = "{icon} {capacity}%";
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format-icons" = {
            "charging" = "󰚥";
            "discharging" = [
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            "full" = "󰁹";
            "not charging" = "󱟢";
            "unknown" = "󱟢";
            "default" = "󱟢";
          };
          "tooltip" = true;
          "tooltip-format" = "{capacity}% - {timeTo}";
        };
        "clock" = {
          "format" = "{:%y-%m-%d %H:%M}";
          "tooltip" = false;
          "menu" = "on-click-right";
          "menu-file" = "~/.config/waybar/notify_menu.xml";
          "menu-actions" = {
            "toggle-dnd" = "fnott-toggle-dnd";
            "clear-all" = "fnottctl dismiss all";
          };
        };
        "custom/notifications" = {
          "exec" = "$HOME/.config/waybar/fnott-status.sh";
          "return-type" = "json";
          "interval" = 2;
          "on-click" = "$HOME/.config/waybar/fnott-toggle.sh";
          "on-click-right" = "fnottctl dismiss all";
          "tooltip" = true;
        };

        ########### Optional ###############
        "power-profiles-daemon" = {
          "format" = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          "tooltip" = true;
          "format-icons" = {
            "default" = "";
            "performance" = "";
            "balanced" = "";
            "power-saver" = "";
          };
        };
      }
    ];
  in
  {
    # Packages that will be installed with the waybar
    environment.systemPackages = with pkgs; [
      easyeffects
      pwvucontrol
      # swaynotificationcenter
      wttrbar
      playerctl
      psmisc # provides fuser for camera-usage.sh
    ];

    home-manager.users.${username} =
      { ... }:
      {

        # Files will be put in ~/.config/waybar which can be executed.
        xdg.configFile = {
          "waybar/notify_menu.xml".text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <interface>
              <object class="GtkMenu" id="menu">
                <child><object class="GtkMenuItem" id="toggle-dnd"><property name="label">Pause Notifications</property></object></child>
                <child><object class="GtkMenuItem" id="clear-all"><property name="label">Clear All Notifications</property></object></child>
              </object>
            </interface>
          '';
          "waybar/vpn-active.sh" = {
            text = ''
              #!/usr/bin/env bash

              # Suche nach aktiven VPN oder WireGuard Verbindungen
              name=$(nmcli -t -f NAME,TYPE connection show --active \
                     | awk -F: '$2=="vpn" || $2=="wireguard"{print $1; exit}')

              [ -n "$name" ] \
                && echo "{\"text\":\"$name\",\"class\":\"connected\",\"percentage\":100}" \
                || echo '{"text":"","class":"disconnected","percentage":0}'

            '';
            executable = true;
          };
          "waybar/microphone-usage.sh" = {
            text = ''
              #!/usr/bin/env bash

              declare -A pids

              for status_file in /proc/asound/card*/pcm*c/sub*/status; do
                [[ -f "$status_file" ]] || continue
                content=$(< "$status_file")
                [[ "$content" == *"state: RUNNING"* ]] || continue

                while IFS= read -r line; do
                  line="''${line#"''${line%%[![:space:]]*}"}"
                  if [[ "$line" == owner_pid* ]]; then
                    pid="''${line#*:}"
                    pid="''${pid// /}"
                    if [[ "$pid" =~ ^[0-9]+$ ]] && (( pid > 0 )); then
                      pids["$pid"]=1
                    fi
                  fi
                done <<< "$content"
              done

              names=()
              for pid in "''${!pids[@]}"; do
                if [[ -r "/proc/$pid/comm" ]]; then
                  name=$(< "/proc/$pid/comm")
                  [[ -n "$name" ]] && names+=("$name")
                fi
              done

              if [[ ''${#names[@]} -gt 0 ]]; then
                apps=$(printf '%s, ' "''${names[@]}")
                apps="''${apps%, }"
                echo "{\"text\": \"󰍬\", \"tooltip\": \"Microphone in use by: ''${apps}\", \"class\": \"in-use\"}"
              else
                echo '{"text": "", "class": "idle"}'
              fi
            '';
            executable = true;
          };
          "waybar/camera-usage.sh" = {
            text = ''
              #!/usr/bin/env bash

              declare -A pids_seen

              shopt -s nullglob
              video_devices=(/dev/video*)
              shopt -u nullglob

              if (( ''${#video_devices[@]} == 0 )); then
                echo '{"text": "", "class": "idle"}'
                exit 0
              fi

              for pid in $(fuser "''${video_devices[@]}" 2>/dev/null || true); do
                if [[ "$pid" =~ ^[0-9]+$ ]]; then
                  pids_seen["$pid"]=1
                fi
              done

              names=()
              for pid in "''${!pids_seen[@]}"; do
                if [[ -r "/proc/$pid/comm" ]]; then
                  name=$(< "/proc/$pid/comm")
                  [[ -n "$name" ]] && names+=("$name")
                fi
              done

              if [[ ''${#names[@]} -gt 0 ]]; then
                apps=$(printf '%s, ' "''${names[@]}")
                apps="''${apps%, }"
                echo "{\"text\": \"󰄀\", \"tooltip\": \"Camera in use by: ''${apps}\", \"class\": \"in-use\"}"
              else
                echo '{"text": "", "class": "idle"}'
              fi
            '';
            executable = true;
          };
          "waybar/fnott-status.sh" = {
            text = ''
              #!/usr/bin/env bash
              if [ -f "$HOME/.cache/fnott-paused" ]; then
                  echo '{"text": "󰂛", "class": "off", "tooltip": "Notifications: OFF (DND)"}'
              else
                  echo '{"text": "󰂚", "class": "on", "tooltip": "Notifications: ON"}'
              fi
            '';
            executable = true;
          };
          "waybar/fnott-toggle.sh" = {
            text = ''
              #!/usr/bin/env bash
              STATE_FILE="$HOME/.cache/fnott-paused"
              if [ -f "$STATE_FILE" ]; then
                  fnottctl unpause
                  rm "$STATE_FILE"
              else
                  fnottctl pause
                  touch "$STATE_FILE"
              fi
            '';
            executable = true;
          };
        };

        programs.waybar = {
          enable = true;
          settings = waybarSettings;

          # CSS-Styling for the Waybar
          style = ''

            @define-color bg #${themeData.ui_colors.bg};
            @define-color border #${themeData.ui_colors.accent};
            @define-color text #${themeData.ui_colors.fg};

            @define-color warning #${themeData.ui_colors.accent};
            @define-color critical #${themeData.colors.red};

            * {
              font-size: 10px;
              font-family: "JetBrainsMono Nerd Font Propo";
              font-weight: Bold;
              padding: 0 4px 0 4px;
              border-radius: 4px;
            }
            window#waybar {
              background: @bg;
              border: Solid;
              border-radius: 0px;
              border-width: 0px;
              border-color: @border;
              color: @text;
            }

            #workspaces button {
              background: transparent;
              border: none;
              color: @text;
              margin: 0;
              transition: none;
            }
            #workspaces button.active {
              background: transparent;
              border: none;
              color: @text;
              margin: 0;
              transition: none;
            }
            /* Stop annoying animations when hovering */
            #workspaces button:hover {
              background: transparent;
              border: none;
              box-shadow: none;
              text-shadow: none;
            }

            #bluetooth, #network, #pulseaudio {
              margin-left: 2px;
              margin-right: 2px;
            }

            /* Box around each element
            #custom-weather, #mpris {
              margin: 2px;
              background-color: rgba(0, 0, 0, 0.3);
              color: @white;
            }
            */

            #idle_inhibitor.activated {
              color: @warning;
            }
            #custom-vpn.connected {
              color: @warning;
            }
            #pulseaudio.muted {
              color: @warning;
            }
            #cpu.warning {
              color: @warning;
            }
            #cpu.critical {
              color: @critical;
            }

            /* Arbeitsspeicher */
            #memory.warning {
              color: @warning;
            }
            #memory.critical {
              color: @critical;
            }

            /* Akkustand */
            #battery.warning {
              color: @warning;
            }
            #battery.critical {
              color: @critical;
            }

            #power-profiles-daemon.performance {
              color: @warning;
            }

            /* Microphone & Camera indicators */
            #custom-microphone.in-use {
              color: @warning;
            }
            #custom-camera.in-use {
              color: @warning;
            }
            #custom-notifications.off {
              color: @warning;
            }
            #custom-notifications.on {
              color: @text;
            }

          '';
        };
      };
  }
)
