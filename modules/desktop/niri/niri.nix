{
  pkgs,
  config,
  lib,
  inputs,
  username,
  ...
}:
lib.mkIf config.modules.desktop.enable {
  services = {
    gnome.gnome-keyring.enable = true;
    logind.settings.Login = {
      HandlePowerKey = "poweroff";
      HandleLidSwitch = "suspend";
      LidSwitchIgnoreInhibited = "no";
    };
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
          PartOf = [ "graphical-session.target" ];
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
          PartOf = [ "graphical-session.target" ];
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
          PartOf = [ "graphical-session.target" ];
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
          Restart = "on-failure";
          RestartSec = 2;
          PartOf = [ "graphical-session.target" ];
        };
      };
    };
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  niri-flake.cache.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    brightnessctl
    cliphist
    fuzzel
    kitty
    networkmanagerapplet
    playerctl
    wl-clipboard
    wl-color-picker
    wofi-power-menu
    xwayland-satellite
    libnotify
    ibus
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
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
      home.file.".config/niri/config.kdl".text = /* kdl */ ''
        include "/home/${username}/.config/niri/noctalia.kdl"
        include "/home/${username}/.config/niri/theme.kdl"

        prefer-no-csd
        screenshot-path "~/Nextcloud/Photos/Sammlungen/Screenshots-Desktop/%Y-%m-%d-%H%M%S.png"

        hotkey-overlay {
            skip-at-startup
        }

        environment {
            NIRI_STRUT_IN_FRACTIONAL_SCALE_AS_INTEGER "1"
            ELM_DISPLAY "wl"
            GDK_BACKEND "wayland,x11"
            MOZ_ENABLE_WAYLAND "1"
            QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
            QT_QPA_PLATFORMTHEME "qt6ct"
            QT_STYLE_OVERRIDE "kvantum"
            SDL_VIDEODRIVER "wayland"
            CLUTTER_BACKEND "wayland"
        }

        spawn-at-startup "sh" "-c" "cliphist wipe"
        spawn-at-startup "sh" "-c" "systemctl --user start cliphist.service"
        spawn-at-startup "sh" "-c" "systemctl --user start cliphist-image.service"
        spawn-at-startup "sh" "-c" "sleep 0.5 && cliphist wipe"
        spawn-at-startup "noctalia"
        spawn-at-startup "sh" "-c" "systemctl --user start xwayland-satellite.service"
        spawn-at-startup "sh" "-c" "systemctl --user start kanshi.service"
        spawn-at-startup "ibus-daemon" "--wayland" "--daemonize" "--replace"
        spawn-at-startup "nm-applet"
        spawn-at-startup "dbus-send" "--session" "--print-reply" "--dest=org.freedesktop.impl.portal.PermissionStore" "/org/freedesktop/impl/portal/PermissionStore" "org.freedesktop.impl.portal.PermissionStore.SetPermission" "string:devices" "boolean:true" "string:camera" "string:org.gnome.Snapshot" "array:string:yes"
        spawn-at-startup "dbus-send" "--session" "--print-reply" "--dest=org.freedesktop.impl.portal.PermissionStore" "/org/freedesktop/impl/portal/PermissionStore" "org.freedesktop.impl.portal.PermissionStore.SetPermission" "string:devices" "boolean:true" "string:camera" "string:" "array:string:yes"

        input {
            keyboard {
                xkb {
                    layout "us"
                    variant "altgr-intl"
                    options "caps:none"
                }
            }
            touchpad {
                accel-speed 0.0;
                natural-scroll;
            }
            mouse { accel-speed 0.0; }
            warp-mouse-to-focus
            focus-follows-mouse max-scroll-amount="25%"
        }

        layout {
            gaps 4
            default-column-width { proportion 0.5; }

            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            preset-window-heights {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
                proportion 1.0
            }

            struts {
                left 8
                right 8
            }
        }

        window-rule {
            geometry-corner-radius 4.0 4.0 4.0 4.0
            clip-to-geometry true
            draw-border-with-background false
        }

        window-rule {
            match app-id="bluetui"
            match app-id="nm-connection-editor"
            match app-id="com.saivert.pwvucontrol"
            match app-id="org.pipewire.Helvum"
            match app-id="wdisplays"
            open-floating true
        }

        window-rule {
            match is-window-cast-target=true
        }

        window-rule {
            match app-id="spotify"
            match app-id=".spotify-wrapped"
            match app-id="discord"
            opacity 0.9
        }

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }
            Mod+E { spawn "kitty"; }
            Mod+P { spawn "firefox"; }
            Mod+Space { spawn "walker"; }
            Mod+Return { spawn "walker"; }
            Mod+Shift+L { spawn "noctalia" "msg" "session" "lock"; }
            Mod+Shift+S { spawn "script-selector"; }
            Mod+N { spawn "fnottctl" "dismiss"; }

            XF86AudioMute allow-when-locked=true { spawn "noctalia" "msg" "volume-mute"; }
            XF86AudioPlay { spawn "sh" "-c" "playerctl play-pause"; }
            XF86AudioPrev { spawn "sh" "-c" "playerctl previous"; }
            XF86AudioNext { spawn "sh" "-c" "playerctl next"; }
            XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-up"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-down"; }
            XF86MonBrightnessUp { spawn "noctalia" "msg" "brightness-up"; }
            XF86MonBrightnessDown { spawn "noctalia" "msg" "brightness-down"; }
            Mod+X { close-window; }

            Mod+H { focus-column-or-monitor-left; }
            Mod+J { focus-window-or-workspace-down; }
            Mod+K { focus-window-or-workspace-up; }
            Mod+L { focus-column-or-monitor-right; }
            Mod+Left { focus-monitor-left; }
            Mod+Down { focus-monitor-down; }
            Mod+Up { focus-monitor-up; }
            Mod+Right { focus-monitor-right; }
            Mod+Home { focus-column-first; }
            Mod+End { focus-column-last; }

            Mod+Ctrl+H { move-column-left-or-to-monitor-left; }
            Mod+Ctrl+J { move-window-down-or-to-workspace-down; }
            Mod+Ctrl+K { move-window-up-or-to-workspace-up; }
            Mod+Ctrl+L { move-column-right-or-to-monitor-right; }
            Mod+Ctrl+Left { move-column-to-monitor-left; }
            Mod+Ctrl+Down { move-column-to-monitor-down; }
            Mod+Ctrl+Up { move-column-to-monitor-up; }
            Mod+Ctrl+Right { move-column-to-monitor-right; }
            Mod+Ctrl+Home { move-column-to-first; }
            Mod+Ctrl+End { move-column-to-last; }

            Mod+Ctrl+Space { toggle-overview; }
            Mod+Shift+XF86TouchpadOff { toggle-overview; }

            Mod+WheelScrollDown { focus-workspace-down; }
            Mod+WheelScrollUp { focus-workspace-up; }
            Mod+Ctrl+WheelScrollDown { move-column-to-workspace-down; }
            Mod+Ctrl+WheelScrollUp { move-column-to-workspace-up; }

            Mod+WheelScrollRight { focus-column-right; }
            Mod+WheelScrollLeft { focus-column-left; }
            Mod+Ctrl+WheelScrollRight { move-column-right; }
            Mod+Ctrl+WheelScrollLeft { move-column-left; }

            Mod+Shift+WheelScrollDown { focus-column-right; }
            Mod+Shift+WheelScrollUp { focus-column-left; }
            Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
            Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }
            Mod+Tab { focus-workspace-previous; }

            Mod+BracketLeft { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }

            Mod+Comma { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+Ctrl+F { expand-column-to-available-width; }
            Mod+C { center-column; }

            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            Mod+V { toggle-window-floating; }
            Mod+Shift+V { switch-focus-between-floating-and-tiling; }

            Mod+W { toggle-column-tabbed-display; }

            Mod+Shift+P { screenshot; }
            Print { screenshot; }
            Alt+Print { screenshot-window; }

            Ctrl+Alt+Delete { quit; }
        }

        switch-events {
            lid-close {
                spawn "sh" "-c" "elapsed=$(ps -o etimes= -C noctalia | head -n1 | tr -d ' '); if [ -n \"$elapsed\" ] && [ \"$elapsed\" -gt 5 ]; then noctalia msg session lock; fi"
            }
        }
      '';
    };
}
