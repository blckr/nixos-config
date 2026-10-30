{ ... }:
{
  # Reduce shutdown timeout to 10 seconds (default is 90s)
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };

  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}
