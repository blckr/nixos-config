{ pkgs }: {
  # Nord Light
  variant = "light";
  opacity = "0.95";
  colors = {
    bg = "e5e9f0";
    bg_alt = "eceff4";
    fg = "2e3440";
    accent = "5e81ac";
    red = "bf616a";
    green = "a3be8c";
    yellow = "ebcb8b";
    blue = "81a1c1";
    magenta = "b48ead";
    cyan = "88c0d0";
    gray = "4c566a";
  };
  ui_colors = {
    bg = "2e3440";
    bg_alt = "242933";
    fg = "d8dee9";
    accent = "88c0d0";
    red = "bf616a";
    green = "a3be8c";
    yellow = "ebcb8b";
    blue = "81a1c1";
    magenta = "b48ead";
    cyan = "88c0d0";
    gray = "4c566a";
  };
  wallpaper = ./../../../pkgs/wallpaper/NordLandscape.png;
  helix-theme = "nord_light";
  kitty-theme = "Nord Light";
  gtk = {
    name = "Nordic-Light";
    package = pkgs.nordic;
    icons = "Papirus-Light";
    iconPackage = pkgs.papirus-icon-theme;
  };
  fish = ''
    set -U fish_color_normal 2e3440
    set -U fish_color_command 5e81ac
    set -U fish_color_quote a3be8c
    set -U fish_color_redirection b48ead
    set -U fish_color_end bf616a
    set -U fish_color_error bf616a
    set -U fish_color_param 3b4252
    set -U fish_color_comment 4c566a
    set -U fish_color_selection --background=d8dee9
    set -U fish_color_search_match --background=d8dee9
    set -U fish_color_operator 88c0d0
    set -U fish_color_escape b48ead
    set -U fish_color_autosuggestion 4c566a
  '';
  zellij = ''
    theme "nord-light"
    themes {
        nord-light {
            fg "#2e3440"
            bg "#e5e9f0"
            black "#d8dee9"
            red "#bf616a"
            green "#a3be8c"
            yellow "#ebcb8b"
            blue "#5e81ac"
            magenta "#b48ead"
            cyan "#88c0d0"
            white "#3b4252"
            orange "#d08770"
        }
    }
  '';
  complement = "nord";
}
