{ pkgs, ... }:
{
  programs.ghostty.package = pkgs.ghostty;

  # Ghostty does not watch its config, SIGUSR2 reloads it. The nixpkgs wrapper runs
  # `.ghostty-wrapped`, truncated by Linux to 15 characters.
  xdg.configFile."ghostty/config".onChange = ''
    ${pkgs.procps}/bin/pkill -USR2 -u "$USER" -x '(ghostty|\.ghostty-wrappe)' || true
  '';
}
