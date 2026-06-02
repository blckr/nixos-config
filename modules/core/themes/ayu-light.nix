{ pkgs }: {
  # Ayu Light
  variant = "light";
  opacity = "0.95";
  colors = {
    bg = "f2eeea";
    bg_alt = "edebea";
    fg = "5c6166";
    accent = "f29718";
    red = "f07178";
    green = "86b300";
    yellow = "f29718";
    blue = "399ee6";
    magenta = "a37acc";
    cyan = "4dbf99";
    gray = "abb0b6";
  };
  ui_colors = {
    bg = "212733";
    bg_alt = "191e2a";
    fg = "d9d7ce";
    accent = "ffad66";
    red = "f28779";
    green = "bae67e";
    yellow = "ffd580";
    blue = "73d0ff";
    magenta = "d4bfff";
    cyan = "95e6cb";
    gray = "686868";
  };
  wallpaper = ./../../../pkgs/wallpaper/RedBlueMountain.png;
  helix-theme = "ayu_light";
  kitty-theme = "Ayu Light";
  gtk = {
    name = "Ayu";
    package = pkgs.ayu-theme-gtk;
    icons = "Adwaita";
    iconPackage = pkgs.adwaita-icon-theme;
  };
  fish = ''
    set -U fish_color_normal 5c6166
    set -U fish_color_command 399ee6
    set -U fish_color_quote f29718
    set -U fish_color_redirection 5c6166
    set -U fish_color_end f07178
    set -U fish_color_error f07178
    set -U fish_color_param 5c6166
    set -U fish_color_comment abb0b6
    set -U fish_color_selection --background=edebea
    set -U fish_color_search_match --background=edebea
    set -U fish_color_operator f29718
    set -U fish_color_escape a37acc
    set -U fish_color_autosuggestion abb0b6
  '';
  zellij = ''
    theme "ayu-light"
    themes {
        ayu-light {
            fg "#5c6166"
            bg "#f2eeea"
            black "#edebea"
            red "#f07178"
            green "#86b300"
            yellow "#f29718"
            blue "#399ee6"
            magenta "#a37acc"
            cyan "#4dbf99"
            white "#5c6166"
            orange "#f29718"
        }
    }
  '';
  complement = "ayu-mirage";
}
