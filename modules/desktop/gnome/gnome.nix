{
  config,
  lib,
  pkgs,
  username,
  ...
}:
lib.mkIf config.modules.desktop.enable {
    services = {
      # desktopManager.gnome is NOT enabled here — niri is the active compositor.
      # Enabling it would start colord, accounts-daemon, bolt, evolution-data-server
      # and a dozen other GNOME background services that waste power on a niri setup.
      # gnome-keyring is enabled separately in niri.nix.
      gnome.gnome-keyring.enable = true;
    };

    security.pam.services.greetd.enableGnomeKeyring = true;

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.paperwm
    ];

    home-manager.users.${username} =
      { pkgs, ... }:
      {
        dconf.settings = {
          "org/gnome/desktop/privacy" = {
            camera-enabled = true;
            disable-camera = false;
          };

          "org/gnome/shell" = {
            enabled-extensions = [ "paperwm@paperwm.github.com" ];
          };

          "org/gnome/shell/extensions/paperwm/keybindings" = {
            # Movement
            switch-left = [ "<Super>h" ];
            switch-right = [ "<Super>l" ];
            switch-up = [ "<Super>k" ];
            switch-down = [ "<Super>j" ];

            # Move windows
            move-left = [ "<Super><Control>h" ];
            move-right = [ "<Super><Control>l" ];
            move-up = [ "<Super><Control>k" ];
            move-down = [ "<Super><Control>j" ];

            # Layout management
            close-window = [ "<Super>x" ];
            maximize-width = [ "<Super>f" ];
            toggle-fullscreen = [ "<Super><Shift>f" ];
            center-window = [ "<Super>c" ];
            cycle-width = [ "<Super>r" ];
            cycle-height = [ "<Super><Shift>r" ];

            # Tiling management (Consume/Expel)
            slurp-in = [ "<Super>bracketleft" ];
            barf-out = [ "<Super>bracketright" ];

            # Overview / Scratch
            toggle-scratch-window = [ "<Super><Control>space" ];
          };

          "org/gnome/desktop/wm/keybindings" = {
            # Disable conflicting defaults
            hide-window = [ ]; # Disables Super+H (Hide)
            show-desktop = [ ];
            panel-main-menu = [ ]; # Disables Super+S (Search/Activities)
            switch-to-workspace-left = [ ];
            switch-to-workspace-right = [ ];

            # Workspace switching (Niri uses Super+1-9)
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            switch-to-workspace-5 = [ "<Super>5" ];
            switch-to-workspace-6 = [ "<Super>6" ];
            switch-to-workspace-7 = [ "<Super>7" ];
            switch-to-workspace-8 = [ "<Super>8" ];
            switch-to-workspace-9 = [ "<Super>9" ];

            # Move to workspaces
            move-to-workspace-1 = [ "<Super><Control>1" ];
            move-to-workspace-2 = [ "<Super><Control>2" ];
            move-to-workspace-3 = [ "<Super><Control>3" ];
            move-to-workspace-4 = [ "<Super><Control>4" ];
            move-to-workspace-5 = [ "<Super><Control>5" ];
            move-to-workspace-6 = [ "<Super><Control>6" ];
            move-to-workspace-7 = [ "<Super><Control>7" ];
            move-to-workspace-8 = [ "<Super><Control>8" ];
            move-to-workspace-9 = [ "<Super><Control>9" ];
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            # Disable conflicting defaults
            screensaver = [ ]; # Disables Super+L (Lock)
            www = [ ]; # Disables Super+W
            search = [ ]; # Disables Super+S

            # Custom keybindings for apps
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            name = "Ghostty";
            command = "ghostty";
            binding = "<Super>e";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            name = "Firefox";
            command = "firefox";
            binding = "<Super>p";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
            name = "Wofi";
            command = "wofi";
            binding = "<Super>space";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
            name = "Lock Session";
            command = "loginctl lock-session";
            binding = "<Super><Shift>l";
          };

          # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          #   name = "SwayNC Toggle";
          #   command = "swaync-client -t";
          #   binding = "<Super>s";
          # };
        };
      };
  }
