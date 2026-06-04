{ pkgs }: {
  # Everforest Light
  variant = "light";
  opacity = "0.95";
  colors = {
    bg = "fdf6e3";
    bg_alt = "f3ead3";
    fg = "5c6a72";
    accent = "8da101";
    red = "f85552";
    green = "8da101";
    yellow = "dfa000";
    blue = "35a77c";
    magenta = "df69ba";
    cyan = "35a77c";
    gray = "939f91";
  };
  ui_colors = {
    bg = "2d353b";
    bg_alt = "232a2e";
    fg = "d3c6aa";
    accent = "a7c080";
    red = "e67e80";
    green = "a7c080";
    yellow = "dbbc7f";
    blue = "7fbbb3";
    magenta = "d699b6";
    cyan = "83c092";
    gray = "859289";
  };
  wallpaper = ./../../../pkgs/wallpaper/GreenTrain.png;
  helix-theme = "everforest_light";
  kitty-theme = "Everforest Light Hard";
  gtk = {
    name = "Everforest-Light";
    package = pkgs.everforest-gtk-theme;
    icons = "Adwaita";
    iconPackage = pkgs.adwaita-icon-theme;
  };
  fish = ''
    set -U fish_color_normal 5c6a72
    set -U fish_color_command 8da101
    set -U fish_color_quote dfa000
    set -U fish_color_redirection 5c6a72
    set -U fish_color_end f85552
    set -U fish_color_error f85552
    set -U fish_color_param 5c6a72
    set -U fish_color_comment 939f91
    set -U fish_color_selection --background=e9e8d2
    set -U fish_color_search_match --background=e9e8d2
    set -U fish_color_operator dfa000
    set -U fish_color_escape df69ba
    set -U fish_color_autosuggestion 939f91
  '';
  zellij = ''
    theme "everforest-light"
    themes {
        everforest-light {
            fg "#5c6a72"
            bg "#fdf6e3"
            black "#f3ead3"
            red "#f85552"
            green "#8da101"
            yellow "#dfa000"
            blue "#35a77c"
            magenta "#df69ba"
            cyan "#35a77c"
            white "#5c6a72"
            orange "#f57d26"
        }
    }
  '';
  complement = "everforest-dark";
}
