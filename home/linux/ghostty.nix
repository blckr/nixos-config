{ pkgs, ... }:
{
  programs.ghostty.package = pkgs.ghostty;

  # Ghostty runs as a single process for all windows and does not watch its config.
  # SIGUSR2 makes it reload, so config changes apply without closing every window.
  # The nixpkgs wrapper runs `.ghostty-wrapped`, and Linux truncates process names
  # to 15 characters, so the process is called `.ghostty-wrappe`.
  xdg.configFile."ghostty/config".onChange = ''
    ${pkgs.procps}/bin/pkill -USR2 -u "$USER" -x '(ghostty|\.ghostty-wrappe)' || true
  '';
}
