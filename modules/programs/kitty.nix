{ pkgs, username, config, ... }:
let
  theme = config.modules.theme.data;
  colors = theme.colors;
  
  # Wrapper shell that kills any zellij sessions when kitty closes.
  kittyShell = pkgs.writeShellScript "kitty-shell" ''
    _cleanup() {
      pkill -P $$ zellij 2>/dev/null || true
      pkill -s $$ zellij 2>/dev/null || true
    }
    trap _cleanup EXIT HUP TERM
    exec ${pkgs.fish}/bin/fish "$@"
  '';
in
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
          background_opacity = theme.opacity;
          confirm_os_window_close = 0;
          allow_remote_control = "yes";
          listen_on = "unix:/tmp/kitty-{kitty_pid}";
          shell = "${kittyShell}";

          background = "#${colors.bg}";
          foreground = "#${colors.fg}";
          cursor = "#${colors.accent}";
          selection_background = "#${colors.accent}";
          selection_foreground = "#${colors.bg}";

          color0  = "#${colors.bg_alt}";
          color1  = "#${colors.red}";
          color2  = "#${colors.green}";
          color3  = "#${colors.yellow}";
          color4  = "#${colors.blue}";
          color5  = "#${colors.magenta}";
          color6  = "#${colors.cyan}";
          color7  = "#${colors.fg}";
          color8  = "#${colors.gray}";
          color9  = "#${colors.red}";
          color10 = "#${colors.green}";
          color11 = "#${colors.yellow}";
          color12 = "#${colors.blue}";
          color13 = "#${colors.magenta}";
          color14 = "#${colors.cyan}";
          color15 = "#ffffff";
        };
      };
    };
}
