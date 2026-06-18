{
  # pkgs,
  username,
  ...
}:
# let
# Wrapper shell that kills any zellij sessions when kitty closes.
# kittyShell = pkgs.writeShellScript "kitty-shell" ''
#   _cleanup() {
#     pkill -P $$ zellij 2>/dev/null || true
#     pkill -s $$ zellij 2>/dev/null || true
#   }
#   trap _cleanup EXIT HUP TERM
#   exec ${pkgs.fish}/bin/fish "$@"
# '';
# in
{
  home-manager.users.${username} =
    { ... }:
    {
      programs.kitty = {
        enable = true;
        settings = {
          editor = "hx";
          term = "xterm-256color";
          window_padding_width = 4;
          background_opacity = 0.95;
          confirm_os_window_close = 0;
          allow_remote_control = "yes";
          listen_on = "unix:/tmp/kitty-{kitty_pid}";
          # shell = "${kittyShell}";
        };

        extraConfig = ''
          include ~/.config/kitty/themes/noctalia.conf
        '';
      };
    };
}
