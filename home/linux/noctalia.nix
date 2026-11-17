{ lib, pkgs, inputs, username, osConfig, settings, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  config = lib.mkIf osConfig.modules.desktop.enable {

    programs.noctalia = {
      enable = true;

      settings = {
        shell = {
          font_family = "Noto Sans";
          settings_show_advanced = true;
          shared_gl_context = true;
          clipboard_enabled = false;
          app_icon_colorize = true;
          corner_radius_scale = 0.3;
          telemetry_enabled = false;
          animation = {
            enabled = true;
            speed = 1.0;
          };
          shadow = {
            direction = "down";
            alpha = 0.55;
          };
          panel = {
            transparency_mode = "solid";
            borders = true;
            shadow = false;
            launcher_placement = "centered";
            clipboard_placement = "centered";
            control_center_placement = "attached";
            wallpaper_placement = "attached";
            session_placement = "attached";
            open_near_click_control_center = true;
          };
          screen_corners = {
            enabled = true;
            size = 14;
          };
        };

        wallpaper = {
          enabled = true;
          fill_mode = "crop";
          transition = [
            "fade"
            "wipe"
            "disc"
            "stripes"
            "zoom"
            "honeycomb"
          ];
          transition_duration = 1500;
          edge_smoothness = 0;
          transition_on_startup = false;
          directory = "/home/${username}/Nextcloud/Archiv/Wallpaper/";
          automation = {
            enabled = false;
          };
          default = {
            path = "${settings.wallpaper}";
          };
        };

        notification = {
          enable_daemon = true;
          layer = "overlay";
          background_opacity = 1.0;
        };

        osd = {
          position = "top_right";
          background_opacity = 1.0;
        };

        lockscreen = {
          blurred_desktop = false;
          blur_intensity = 0.0;
          tint_intensity = 0.0;
        };

        audio = {
          enable_overdrive = false;
          enable_sounds = false;
          sound_volume = 0.5;
        };

        battery = {
          warning_threshold = 30;
        };

        brightness = {
          enable_ddcutil = false;
        };

        nightlight = {
          enabled = false;
          force = false;
          temperature_day = 6500;
          temperature_night = 4000;
        };

        location = {
          auto_locate = true;
        };

        calendar = {
          enabled = true;
        };

        idle = {
          pre_action_fade_seconds = 30;
          behavior = {
            lock = {
              timeout = 300;
              command = "noctalia:session lock";
              enabled = true;
            };
            screen-off = {
              timeout = 300;
              command = "niri msg action power-off-monitors";
              resume_command = "niri msg action power-on-monitors";
              enabled = true;
            };
            suspend = {
              timeout = 1800;
              command = "systemctl suspend";
              enabled = true;
            };
          };
        };

        keybinds = {
          validate = [
            "return"
            "kp_enter"
          ];
          cancel = [ "escape" ];
          left = [ "left" ];
          right = [ "right" ];
          up = [ "up" ];
          down = [ "down" ];
        };

        bar = {
          main = {
            position = "bottom";
            thickness = 32;
            background_opacity = 1.0;
            radius = 0;
            capsule_radius = 4;
            margin_ends = 0;
            margin_edge = 0;
            padding = 8;
            widget_spacing = 8;
            scale = 1.0;
            shadow = false;
            auto_hide = false;
            reserve_space = true;
            capsule = false;
            start = [
              "workspaces"
              "media"
              # "theme_mode"
            ];
            center = [ "taskbar" ];
            end = [
              "tray"
              "battery"
              "clock"
              "notifications"
            ];
          };
        };

        dock = {
          enabled = false;
          position = "bottom";
          auto_hide = true;
          reserve_space = false;
          margin_ends = 0;
          margin_edge = 8;
        };

        desktop_widgets = {
          enabled = false;
        };

        control_center = {
          shortcuts = [
            { type = "wifi"; }
            { type = "bluetooth"; }
            { type = "caffeine"; }
            { type = "power_profile"; }
          ];
        };

        widget = {
          clock = {
            type = "clock";
            format = "{:%y-%m-%d  %H:%M}";
          };
          control-center = {
            type = "control-center";
            custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            custom_image_colorize = true;
          };
          workspaces = {
            type = "workspaces";
            minimal = false;
            display = "name";
            max_label_chars = 12;
          };
          media = {
            type = "media";
            hide_when_no_media = true;
          };
          notifications = {
            type = "notifications";
            hide_when_no_unread = true;
          };
          sysmon = {
            type = "sysmon";
            display = "gauge";
          };
          cpu = {
            type = "sysmon";
            stat = "cpu_usage";
            show_value = false;
          };
          temp = {
            type = "sysmon";
            stat = "cpu_temp";
            show_value = false;
          };
          ram = {
            type = "sysmon";
            stat = "ram_used";
            show_value = false;
          };
          battery = {
            display_mode = "graphic";
            scale = 0.75;
            show_value = false;
          };
          taskbar = {
            color = "primary";
            empty_color = "tertiary";
            group_by_workspace = true;
            hide_empty_workspaces = true;
            inactive_opacity = 0.8;
            occupied_color = "tertiary";
            workspace_label_placement = "centered";
          };
          tray = {
            drawer = true;
            drawer_columns = 4;
          };
          volume = {
            show_value = false;
          };
        };

        # palette and mode are set in ./appearance.nix
        theme = {
          templates = {
            enable_builtin_templates = false;
            enable_community_templates = false;
          };
        };
      };
    };
  };
}
