{
  lib,
  pkgs,
  config,
  username,
  ...
}:
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%H:%M | %A, %d. %B' --remember --remember-user-session --asterisks --cmd niri-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions";
        user = "greeter";
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
