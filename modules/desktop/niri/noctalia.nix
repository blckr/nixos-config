{
  config,
  lib,
  username,
  inputs,
  pkgs,
  ...
}:
lib.mkIf config.modules.desktop.enable {

  home-manager.users.${username} = {

    imports = [ inputs.noctalia.homeModules.default ];

    # ==========================================================
    # NOCTALIA KONFIGURATION
    # ==========================================================

    programs.noctalia = {
      enable = true;

      settings = {
        # Shell
        shell = {
          font_family = "noto-sans";
          settings_show_advanced = true;
          shared_gl_context = true;
          clipboard_enabled = false;
          app_icon_colorize = true;
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
          };
        };

        # Wallpaper
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
        };

        # Notification
        notification = {
          enable_daemon = true;
          layer = "overlay";
          background_opacity = 1.0;
        };

        # OSD
        osd = {
          position = "top_right";
          background_opacity = 1.0;
        };

        # Lock Screen
        lockscreen = {
          blurred_desktop = false;
          blur_intensity = 0.0;
          tint_intensity = 0.0;
        };

        # Audio
        audio = {
          enable_overdrive = false;
          enable_sounds = false;
          sound_volume = 0.5;
        };

        # Brightness
        brightness = {
          enable_ddcutil = false;
        };

        # Night Light
        nightlight = {
          enabled = false;
          force = false;
          temperature_day = 6500;
          temperature_night = 4000;
        };

        # Location
        location = {
          auto_locate = true;
        };

        # Idle
        idle = {
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

        # Keybinds
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

        # Bar
        bar = {
          main = {
            position = "bottom";
            thickness = 32;
            background_opacity = 0.93;
            radius = 4;
            margin_ends = 0;
            margin_edge = 0;
            padding = 4;
            widget_spacing = 8;
            scale = 1.0;
            shadow = false;
            auto_hide = false;
            reserve_space = true;
            capsule = false;
            start = [
              "workspaces"
              # "cpu"
              # "temp"
              # "ram"
              "media"
            ];
            center = [ "control-center" ];
            end = [
              "tray"
              "volume"
              "battery"
              "clock"
              "notifications"
            ];
          };
        };

        # Dock
        dock = {
          enabled = false;
          position = "bottom";
          auto_hide = true;
          reserve_space = false;
          margin_ends = 0;
          margin_edge = 8;
        };

        # Desktop Widgets
        desktop_widgets = {
          enabled = false;
        };

        # Control Center
        control_center = {
          shortcuts = [
            { type = "wifi"; }
            { type = "bluetooth"; }
            { type = "wallpaper"; }
            { type = "screen_recorder"; }
          ];
        };

        # Widgets
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
            show_label = false;
          };
          temp = {
            type = "sysmon";
            stat = "cpu_temp";
            show_label = false;
          };
          ram = {
            type = "sysmon";
            stat = "ram_used";
            show_label = false;
          };
        };

        # ==========================================================
        # TEMPLATES
        # ==========================================================
        theme = {
          templates = {
            enable_builtin_templates = true;
            builtin_ids = [
              "gtk3"
              "gtk4"
              "qt"
            ];
            user = {
              zellij = {
                input_path = "$XDG_CONFIG_HOME/noctalia/templates/zellij.kdl";
                output_path = "$XDG_CONFIG_HOME/zellij/themes/noctalia.kdl";
              };
              walker = {
                input_path = "$XDG_CONFIG_HOME/noctalia/templates/walker.css";
                output_path = "$XDG_CONFIG_HOME/walker/themes/noctalia-colors.css";
                post_hook = "systemctl --user restart walker";
              };
              firefox = {
                input_path = "$XDG_CONFIG_HOME/noctalia/templates/firefox-colors.css";
                output_path = "/home/${username}/.mozilla/firefox/default/chrome/noctalia-colors.css";
              };
              thunderbird = {
                input_path = "$XDG_CONFIG_HOME/noctalia/templates/thunderbird-colors.css";
                output_path = "/home/${username}/.thunderbird/default/chrome/noctalia-colors.css";
              };
              dconf_sync = {
                input_path = "$XDG_CONFIG_HOME/noctalia/templates/dconf-sync.sh";
                output_path = "/tmp/noctalia-dconf-sync.sh";
                post_hook = "bash /tmp/noctalia-dconf-sync.sh";
              };
              niri = {
                input_path = "$XDG_CONFIG_HOME/noctalia/templates/niri-theme.kdl";
                output_path = "/home/${username}/.config/niri/theme.kdl";
                post_hook = "niri msg action reload-config";
              };
            };
          };
        };
      };
    };
    xdg.configFile."noctalia/templates/zellij.kdl" = {
      text = "themes {\n  noctalia {\n    fg \"{{ colors.terminal_foreground.default.hex }}\"\n    bg \"{{ colors.terminal_background.default.hex }}\"\n    black \"{{ colors.terminal_normal_black.default.hex }}\"\n    red \"{{ colors.terminal_normal_red.default.hex }}\"\n    green \"{{ colors.terminal_normal_green.default.hex }}\"\n    yellow \"{{ colors.terminal_normal_yellow.default.hex }}\"\n    blue \"{{ colors.terminal_normal_blue.default.hex }}\"\n    magenta \"{{ colors.terminal_normal_magenta.default.hex }}\"\n    cyan \"{{ colors.terminal_normal_cyan.default.hex }}\"\n    white \"{{ colors.terminal_normal_white.default.hex }}\"\n    orange \"{{ colors.terminal_bright_yellow.default.hex }}\"\n  }\n}";
    };

    xdg.configFile."noctalia/templates/walker.css" = {
      text = "@define-color bg {{ colors.surface.default.hex }};\n@define-color fg {{ colors.on_surface.default.hex }};\n@define-color accent {{ colors.primary.default.hex }};\n@define-color selection {{ colors.surface_container_highest.default.hex }};\n@define-color border {{ colors.outline_variant.default.hex }};";
    };

    xdg.configFile."noctalia/templates/firefox-colors.css" = {
      text = ''
        :root {
          --gnome-window-background: {{ colors.surface.default.hex }} !important;
          --gnome-window-foreground: {{ colors.on_surface.default.hex }} !important;
          --gnome-view-background: {{ colors.surface.default.hex }} !important;
          --gnome-view-foreground: {{ colors.on_surface.default.hex }} !important;
          --gnome-headerbar-background: {{ colors.surface_container.default.hex }} !important;
          --gnome-headerbar-foreground: {{ colors.on_surface.default.hex }} !important;
          --gnome-headerbar-backdrop-background: {{ colors.surface.default.hex }} !important;

          --gnome-accent-bg: {{ colors.primary.default.hex }} !important;
          --gnome-accent-fg: {{ colors.on_primary.default.hex }} !important;

          --gnome-popover-background: {{ colors.surface_container_high.default.hex }} !important;
          --gnome-popover-foreground: {{ colors.on_surface.default.hex }} !important;

          --gnome-card-background: {{ colors.surface_container_high.default.hex }} !important;
          --gnome-card-foreground: {{ colors.on_surface.default.hex }} !important;

          --gnome-sidebar-background: {{ colors.surface_container_low.default.hex }} !important;
          --gnome-sidebar-foreground: {{ colors.on_surface.default.hex }} !important;

          --gnome-dialog-background: {{ colors.surface.default.hex }} !important;
          --gnome-dialog-foreground: {{ colors.on_surface.default.hex }} !important;
        }
      '';
    };

    xdg.configFile."noctalia/templates/thunderbird-colors.css" = {
      text = ''
        :root {
          --gnome-window-background: {{ colors.surface.default.hex }} !important;
          --gnome-window-foreground: {{ colors.on_surface.default.hex }} !important;
          --gnome-view-background: {{ colors.surface.default.hex }} !important;
          --gnome-view-foreground: {{ colors.on_surface.default.hex }} !important;
          --gnome-headerbar-background: {{ colors.surface_container.default.hex }} !important;
          --gnome-headerbar-foreground: {{ colors.on_surface.default.hex }} !important;
          --gnome-headerbar-backdrop-background: {{ colors.surface.default.hex }} !important;

          --gnome-accent-bg: {{ colors.primary.default.hex }} !important;
          --gnome-accent-fg: {{ colors.on_primary.default.hex }} !important;

          --gnome-popover-background: {{ colors.surface_container_high.default.hex }} !important;
          --gnome-popover-foreground: {{ colors.on_surface.default.hex }} !important;

          --gnome-card-background: {{ colors.surface_container_high.default.hex }} !important;
          --gnome-card-foreground: {{ colors.on_surface.default.hex }} !important;

          --gnome-sidebar-background: {{ colors.surface_container_low.default.hex }} !important;
          --gnome-sidebar-foreground: {{ colors.on_surface.default.hex }} !important;

          --gnome-dialog-background: {{ colors.surface.default.hex }} !important;
          --gnome-dialog-foreground: {{ colors.on_surface.default.hex }} !important;
        }
      '';
    };

    xdg.configFile."noctalia/templates/niri-theme.kdl" = {
      text = ''
        layout {
            focus-ring {
                off
            }
            border {
                on
                width 2
                active-color "{{ colors.primary.default.hex }}"
                inactive-color "{{ colors.surface_container_highest.default.hex }}"
            }
        }
      '';
    };
    xdg.configFile."noctalia/templates/dconf-sync.sh" = {
      text = ''
        #!/usr/bin/env bash
        SURFACE="{{ colors.surface.default.hex }}"
        SURFACE_HEX=''${SURFACE#*#}
        R=$(printf "%d" 0x''${SURFACE_HEX:0:2})
        G=$(printf "%d" 0x''${SURFACE_HEX:2:2})
        B=$(printf "%d" 0x''${SURFACE_HEX:4:2})
        LUMA=$(( (R * 299 + G * 587 + B * 114) / 1000 ))
        if [ "$LUMA" -gt 127 ]; then
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
        else
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        fi
      '';
    };
  };
}
