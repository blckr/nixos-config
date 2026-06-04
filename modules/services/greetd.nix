{ lib, pkgs, config, username, ... }:
{
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "console=tty12"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  services.displayManager.sessionPackages = [
    pkgs.niri
  ];

  environment.etc."share/wayland-sessions/gnome.desktop".text = ''
    [Desktop Entry]
    Name=GNOME
    Comment=This session logs you into GNOME
    Exec=${pkgs.gnome-session}/bin/gnome-session
    TryExec=${pkgs.gnome-session}/bin/gnome-session
    Type=Application
    DesktopNames=GNOME
  '';

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd niri-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions";
        user = "greeter";
      };
      initial_session = {
        command = "${pkgs.bash}/bin/bash --login -c 'export LOCK_ON_STARTUP=1; exec niri-session'";
        user = username;
      };
    };
  };

  # Fine-tune the greetd systemd service for running a TUI/GUI greeter properly
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Disable getty on tty1 to prevent conflict with greetd
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
