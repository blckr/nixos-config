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

        # Zusatz-Alt zu den Standard-Shortcuts: gleiche Aktion, aber im
        # aktuellen Arbeitsverzeichnis (benötigt Shell-Integration mit cwd-Reporting).
        #   C-S-t     -> neuer Tab        | C-S-A-t     -> Tab im pwd
        #   C-S-Enter -> neuer Split      | C-S-A-Enter -> Split im pwd
        #   C-S-n     -> neues OS-Fenster | C-S-A-n     -> OS-Fenster im pwd
        keybindings = {
          "ctrl+shift+alt+t" = "new_tab_with_cwd";
          "ctrl+shift+alt+enter" = "new_window_with_cwd";
          "ctrl+shift+alt+n" = "new_os_window_with_cwd";
        };

        extraConfig = ''
          include ~/.config/kitty/themes/noctalia.conf
        '';
      };
    };
}
