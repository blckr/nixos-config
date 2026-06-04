{ pkgs }:
{
  # Nord
  variant = "dark";
  opacity = "0.9";
  colors = {
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
  helix-theme = "nord";
  kitty-theme = "Nord";
  gtk = {
    name = "Nordic";
    package = pkgs.nordic;
    icons = "Papirus-Dark";
    iconPackage = pkgs.papirus-icon-theme;
  };
  fish = /* sh */ ''
    set -U fish_color_normal d8dee9
    set -U fish_color_command 81a1c1
    set -U fish_color_quote a3be8c
    set -U fish_color_redirection b48ead
    set -U fish_color_end bf616a
    set -U fish_color_error bf616a
    set -U fish_color_param e5e9f0
    set -U fish_color_comment 4c566a
    set -U fish_color_selection --background=434c5e
    set -U fish_color_search_match --background=434c5e
    set -U fish_color_operator 88c0d0
    set -U fish_color_escape b48ead
    set -U fish_color_autosuggestion 4c566a
  '';
  zellij = ''
    theme "nord"
    themes {
        nord {
            fg "#d8dee9"
            bg "#2e3440"
            black "#3b4252"
            red "#bf616a"
            green "#a3be8c"
            yellow "#ebcb8b"
            blue "#81a1c1"
            magenta "#b48ead"
            cyan "#88c0d0"
            white "#e5e9f0"
            orange "#d08770"
        }
    }
  '';
  complement = "nord-light";
}
