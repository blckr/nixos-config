{
  pkgs,
  inputs,
  username,
  ...
}:
let
  bgImage = ./../../pkgs/wallpaper/RedBlueMountain.png;
in
{
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    logind.settings.Login.HandlePowerKey = "poweroff";
    logind.settings.Login.HandleLidSwitch = "suspend";
  };

  security.pam.services.niri.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  systemd = {
    user.services = {
      # Polkit
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      niri-flake-polkit.enable = false;

      cliphist = {
        description = "wl-paste + cliphist service";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store --text";
          StandardOutput = "journal";
          StandardError = "journal";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      cliphist-image = {
        description = "wl-paste + cliphist service for pictures";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store --image";
          StandardOutput = "journal";
          StandardError = "journal";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      swaybg = {
        description = "swaybg service";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${bgImage}";
          Restart = "on-failure";
        };
      };

      swayosd-libinput-backend = {
        description = "SwayOSD LibInput backend";
        documentation = [ "https://github.com/ErikReider/SwayOSD" ];
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
          Restart = "on-failure";
          RestartSec = 2;
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };

      xwayland-satellite = {
        description = "xwayland-satellite";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "notify";
          ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
          NotifyAccess = "all";
          Restart = "always";
          RestartSec = 2;
        };
      };
    };
  };

  services.udev.packages = with pkgs; [
    swayosd
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  niri-flake.cache.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    brightnessctl
    cliphist
    hypridle
    hyprlock
    ghostty
    fuzzel
    kitty
    networkmanagerapplet
    playerctl
    swaynotificationcenter
    swayosd
    wl-clipboard
    # wl-clip-persist
    wl-color-picker
    wofi-power-menu
    xwayland-satellite
  ];

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri;
    };

    dconf.enable = true;
    ssh.askPassword = "";
    xwayland.enable = true;
  };

  home-manager.users.${username} =
    { pkgs, config, ... }:
    {
      dconf.settings."org/blueman/general".plugin-list = [
        "StatusIcon"
        "ShowConnected"
        "!ExitItem"
      ];

      services.hypridle.enable = true;
      programs = {
        waybar.enable = true;
        wofi.enable = true;

        niri = {
          settings = {
            prefer-no-csd = true;
            hotkey-overlay.skip-at-startup = true;
            screenshot-path = "~/Nextcloud/Photos/Sammlungen/Screenshots-Desktop/%Y-%m-%d-%H%M%S.png";

            environment = {
              ELM_DISPLAY = "wl";
              GDK_BACKEND = "wayland,x11";
              # MOZ_ENABLE_WAYLAND = "1"; # Run Firefox under Wayland
              QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
              SDL_VIDEODRIVER = "wayland";
              CLUTTER_BACKEND = "wayland";
            };

            spawn-at-startup =
              let
                sh = [
                  "sh"
                  "-c"
                ];
              in
              [
                # { command = sh ++ [ "wl-clip-persist --clipboard regular" ]; } #Might cause Problems
                { command = sh ++ [ "cliphist wipe" ]; }
                { command = sh ++ [ "systemctl --user start cliphist.service" ]; }
                { command = sh ++ [ "systemctl --user start cliphist-image.service" ]; }
                { command = sh ++ [ "sleep 0.5 && cliphist wipe" ]; }
                { command = sh ++ [ "systemctl --user start hypridle.service" ]; }
                { command = sh ++ [ "systemctl --user start waybar.service" ]; }
                { command = sh ++ [ "systemctl --user start xwayland-satellite.service" ]; }
                { command = sh ++ [ "systemctl --user start swaybg.service" ]; }
                { command = sh ++ [ "systemctl --user start swaync.service" ]; }
                { command = sh ++ [ "systemctl --user start kanshi.service" ]; }
                { command = sh ++ [ "sleep 1 && blueman-applet" ]; }
                { command = sh ++ [ "id=0" ]; }
                { command = [ "nm-applet" ]; }
              ];

            input = {
              power-key-handling.enable = false;
              warp-mouse-to-focus.enable = true;

              mouse = {
                accel-speed = 0.0;
              };

              touchpad = {
                accel-speed = 0.0;
              };

              keyboard.xkb.layout = "us";
              keyboard.xkb.variant = "altgr-intl";
              keyboard.xkb.options = "caps:none";

              focus-follows-mouse = {
                enable = true;
                max-scroll-amount = "25%";
              };
            };

            binds =
              with config.lib.niri.actions;
              let
                sh = spawn "sh" "-c";
              in
              {
                # Overlay
                "Super+Shift+Slash".action = show-hotkey-overlay;

                # Tools
                "Super+E".action = spawn "kitty";
                # "Super+P".action = spawn "firefox";
                "Super+P".action = spawn "zen";
                "Super+Space".action = spawn "wofi";
                "Super+Return".action = spawn "wofi";
                "Super+Shift+L".action = spawn "loginctl" "lock-session";

                "Super+S".action = sh "swaync-client -t";
                "Super+A".action = sh "cliphist list | wofi -S dmenu | cliphist decode | wl-copy";

                "XF86AudioMute".action = sh "swayosd-client --output-volume=mute-toggle";
                "XF86AudioPlay".action = sh "playerctl play-pause";
                "XF86AudioPrev".action = sh "playerctl previous";
                "XF86AudioNext".action = sh "playerctl next";
                "XF86AudioRaiseVolume".action = sh "swayosd-client --output-volume=raise";
                "XF86AudioLowerVolume".action = sh "swayosd-client --output-volume=lower";
                "XF86MonBrightnessUp".action = sh "swayosd-client --brightness=raise";
                "XF86MonBrightnessDown".action = sh "swayosd-client --brightness=lower";
                # Close window
                "Super+X".action = close-window;

                # Focus (movement)
                "Super+H".action = focus-column-or-monitor-left;
                "Super+J".action = focus-window-or-workspace-down;
                "Super+K".action = focus-window-or-workspace-up;
                "Super+L".action = focus-column-or-monitor-right;
                "Super+Left".action = focus-monitor-left;
                "Super+Down".action = focus-monitor-down;
                "Super+Up".action = focus-monitor-up;
                "Super+Right".action = focus-monitor-right;
                "Super+Home".action = focus-column-first;
                "Super+End".action = focus-column-last;

                # Move windows
                "Super+Ctrl+H".action = move-column-left-or-to-monitor-left;
                "Super+Ctrl+J".action = move-window-down-or-to-workspace-down;
                "Super+Ctrl+K".action = move-window-up-or-to-workspace-up;
                "Super+Ctrl+L".action = move-column-right-or-to-monitor-right;
                "Super+Ctrl+Left".action = move-column-to-monitor-left;
                "Super+Ctrl+Down".action = move-column-to-monitor-down;
                "Super+Ctrl+Up".action = move-column-to-monitor-up;
                "Super+Ctrl+Right".action = move-column-to-monitor-right;
                "Super+Ctrl+Home".action = move-column-to-first;
                "Super+Ctrl+End".action = move-column-to-last;

                # Overview toggle
                "Super+Ctrl+Space".action = toggle-overview;
                # Rebinding the Copilot-Key: Touchpad works, even tho wev says it should be Assistant
                "Super+Shift+XF86TouchpadOff".action = toggle-overview;
                # "XF86Assistant".action = toggle-overview;
                # "Super+Shift+XF86Assistant".action = toggle-overview;

                # Mouse wheel – switch workspace (cooldown 150 ms)
                "Super+WheelScrollDown".action = focus-workspace-down;
                "Super+WheelScrollUp".action = focus-workspace-up;
                "Super+Ctrl+WheelScrollDown".action = move-column-to-workspace-down;
                "Super+Ctrl+WheelScrollUp".action = move-column-to-workspace-up;

                # Mouse wheel – switch column
                "Super+WheelScrollRight".action = focus-column-right;
                "Super+WheelScrollLeft".action = focus-column-left;
                "Super+Ctrl+WheelScrollRight".action = move-column-right;
                "Super+Ctrl+WheelScrollLeft".action = move-column-left;

                # Mouse wheel + Shift (horizontal scrolling)
                "Super+Shift+WheelScrollDown".action = focus-column-right;
                "Super+Shift+WheelScrollUp".action = focus-column-left;
                "Super+Ctrl+Shift+WheelScrollDown".action = move-column-right;
                "Super+Ctrl+Shift+WheelScrollUp".action = move-column-left;

                # Workspaces
                "Super+1".action = focus-workspace 1;
                "Super+2".action = focus-workspace 2;
                "Super+3".action = focus-workspace 3;
                "Super+4".action = focus-workspace 4;
                "Super+5".action = focus-workspace 5;
                "Super+6".action = focus-workspace 6;
                "Super+7".action = focus-workspace 7;
                "Super+8".action = focus-workspace 8;
                "Super+9".action = focus-workspace 9;
                "Super+Tab".action = focus-workspace-previous;

                # Consume or expel window from column
                "Super+BracketLeft".action = consume-or-expel-window-left;
                "Super+BracketRight".action = consume-or-expel-window-right;

                # Individual window in column
                "Super+Comma".action = consume-window-into-column;
                "Super+Period".action = expel-window-from-column;

                # Presets & sizing
                "Super+R".action = switch-preset-column-width;
                "Super+Shift+R".action = switch-preset-window-height;
                "Super+Ctrl+R".action = reset-window-height;
                "Super+F".action = maximize-column;
                "Super+Shift+F".action = fullscreen-window;
                "Super+Ctrl+F".action = expand-column-to-available-width;
                "Super+C".action = center-column;

                # Fine adjustments
                "Super+Minus".action = set-column-width "-10%";
                "Super+Equal".action = set-column-width "+10%";
                "Super+Shift+Minus".action = set-window-height "-10%";
                "Super+Shift+Equal".action = set-window-height "+10%";

                # Floating vs. tiling
                "Super+V".action = toggle-window-floating;
                "Super+Shift+V".action = switch-focus-between-floating-and-tiling;

                # Tabbed column display
                "Super+W".action = toggle-column-tabbed-display;

                # Screenshots
                "Super+Shift+P".action.screenshot = [ ];
                "Print".action.screenshot = [ ];
                "Alt+Print".action.screenshot-window = [ ];

                # Session & power
                "Ctrl+Alt+Delete".action = quit;
                # "Super+Shift+P".action   = power-off-monitors;
              };

            gestures.hot-corners.enable = true;

            layout = {
              gaps = 0;
              default-column-width.proportion = 0.5;
              insert-hint.display = {
                color = "rgba(28, 28, 44, 30%)";
              };

              preset-column-widths = [
                { proportion = 1.0 / 3.0; }
                { proportion = 0.5; }
                { proportion = 2.0 / 3.0; }
              ];

              preset-window-heights = [
                { proportion = 1.0 / 3.0; }
                { proportion = 0.5; }
                { proportion = 2.0 / 3.0; }
                { proportion = 1.0; }
              ];

              # Creates the Border around each windowpreset-window-heights
              border = {
                enable = true;
                width = 3;
                active =
                  # aqua0
                  # { color = "rgba(104, 157, 106, 1)"; };
                  # orange (ayu_mirage)
                  {
                    color = "#ffad66";
                  };
                inactive =
                  # fg0
                  # { color = "rgba(235, 219, 178, 1)"; };
                  {
                    color = "#1f2439";
                  };

              };

              # No Focus ring as it creates a variable width, which brings noise in my opinion. The border active/inactive is enough
              focus-ring.enable = false;

              # For Grouping Windows in Tabs (Super+W)
              tab-indicator = {
                enable = true;
                place-within-column = true;
                width = 8;
                corner-radius = 0;
                gap = 0;
                gaps-between-tabs = 0;
                position = "bottom";
                active = {
                  # aqua0
                  # color = "rgba(104, 157, 106, 1)";
                  color = "#ffad66";
                };
                inactive = {
                  # fg0
                  # color = "rgba(251, 241, 199, 1)";
                  color = "#1f2439";
                };
                length.total-proportion = 1.0;
              };
            };
            # bg1
            # overview.backdrop-color = "rgb(60,56,54)";
            overview.backdrop-color = "#1f2439";

            window-rules = [
              {
                geometry-corner-radius =
                  let
                    radius = 0.0;
                  in
                  {
                    bottom-left = radius;
                    bottom-right = radius;
                    top-left = radius;
                    top-right = radius;
                  };
                clip-to-geometry = true;
                draw-border-with-background = false;
              }
              {
                matches = [
                  { app-id = ".blueman-manager-wrapped"; }
                  { app-id = "nm-connection-editor"; }
                  { app-id = "com.saivert.pwvucontrol"; }
                  { app-id = "org.pipewire.Helvum"; }
                  { app-id = "com.github.wwmm.easyeffects"; }
                  { app-id = "wdisplays"; }
                ];
                open-floating = true;
              }
              {
                matches = [
                  { is-window-cast-target = true; }
                ];
              }
            ];
          };
        };
      };
    };
}
