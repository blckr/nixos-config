{ pkgs, ... }:
{
  programs.ghostty.package = pkgs.ghostty;

  # Ghostty runs as a single process for all windows and does not watch its config.
  # SIGUSR2 makes it reload, so config changes apply without closing every window.
  xdg.configFile."ghostty/config".onChange = ''
    ${pkgs.procps}/bin/pkill -USR2 -x ghostty || true
  '';
}
