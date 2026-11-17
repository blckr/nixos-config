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
