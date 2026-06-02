{ pkgs }: {
  # Dracula
  variant = "dark";
  opacity = "0.9";
  colors = {
    bg = "282a36";
    bg_alt = "1e1f29";
    fg = "f8f8f2";
    accent = "bd93f9";
    red = "ff5555";
    green = "50fa7b";
    yellow = "f1fa8c";
    blue = "6272a4";
    magenta = "ff79c6";
    cyan = "8be9fd";
    gray = "44475a";
  };
  ui_colors = {
    bg = "282a36";
    bg_alt = "1e1f29";
    fg = "f8f8f2";
    accent = "bd93f9";
    red = "ff5555";
    green = "50fa7b";
    yellow = "f1fa8c";
    blue = "6272a4";
    magenta = "ff79c6";
    cyan = "8be9fd";
    gray = "44475a";
  };
  wallpaper = ./../../../pkgs/wallpaper/everforest.png;
  helix-theme = "dracula";
  kitty-theme = "Dracula";
  gtk = {
    name = "Dracula";
    package = pkgs.dracula-theme;
    icons = "Dracula";
    iconPackage = pkgs.dracula-icon-theme;
  };
  fish = ''
    set -U fish_color_normal f8f8f2
    set -U fish_color_command bd93f9
    set -U fish_color_quote f1fa8c
    set -U fish_color_redirection f8f8f2
    set -U fish_color_end ff79c6
    set -U fish_color_error ff5555
    set -U fish_color_param f8f8f2
    set -U fish_color_comment 6272a4
    set -U fish_color_selection --background=44475a
    set -U fish_color_search_match --background=44475a
    set -U fish_color_operator 50fa7b
    set -U fish_color_escape ff79c6
    set -U fish_color_autosuggestion 6272a4
  '';
  zellij = ''
    theme "dracula"
    themes {
        dracula {
            fg "#f8f8f2"
            bg "#282a36"
            black "#000000"
            red "#ff5555"
            green "#50fa7b"
            yellow "#f1fa8c"
            blue "#6272a4"
            magenta "#ff79c6"
            cyan "#8be9fd"
            white "#ffffff"
            orange "#ffb86c"
        }
    }
  '';
}
