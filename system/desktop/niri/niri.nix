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
      HandleLidSwitchExternalPower = "suspend";
      # Suspend on lid close even while an app (e.g. video playback) inhibits idle
      LidSwitchIgnoreInhibited = "yes";
    };
  };

  security.pam.services.niri.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  systemd = {
    user.timers.niri-display-hz = {
      wantedBy = [ "graphical-session.target" ];
      timerConfig = {
        OnActiveSec = "5s";
        OnUnitActiveSec = "30s";
      };
    };

    user.services.niri-display-hz = {
      description = "Set display Hz to 60 on battery, 120 on AC";
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = let
          script = pkgs.writeShellScript "niri-display-hz" ''
            if [ "$(cat /sys/class/power_supply/AC/online 2>/dev/null)" = "1" ]; then
              ${pkgs.niri}/bin/niri msg output "eDP-1" mode 2880x1800@120.000 || true
            else
              ${pkgs.niri}/bin/niri msg output "eDP-1" mode 2880x1800@60.000 || true
            fi
          '';
        in "${script}";
      };
    };
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  niri-flake.cache.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    brightnessctl
    fuzzel
    ghostty
    playerctl
    wl-clipboard
    wl-color-picker
    wofi-power-menu
    xwayland-satellite
    libnotify
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
}
