{ pkgs }: {
  # Ayu Mirage
  variant = "dark";
  opacity = "0.9";
  colors = {
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
  helix-theme = "ayu_mirage";
  kitty-theme = "ayu_mirage";
  gtk = {
    name = "TokyoNight";
    package = pkgs.tokyonight-gtk-theme;
    icons = "Papirus-Dark";
    iconPackage = pkgs.papirus-icon-theme;
  };
  fish = ''
    set -U fish_color_normal d9d7ce
    set -U fish_color_command 5cc9ff
    set -U fish_color_quote ffc35c
    set -U fish_color_redirection d9d7ce
    set -U fish_color_end f28779
    set -U fish_color_error f28779
    set -U fish_color_param d9d7ce
    set -U fish_color_comment 565b66
    set -U fish_color_selection --background=30394a
    set -U fish_color_search_match --background=30394a
    set -U fish_color_operator ffc35c
    set -U fish_color_escape 95e6cb
    set -U fish_color_autosuggestion 565b66
  '';
  zellij = ''
    theme "ayu-mirage"
    themes {
        ayu-mirage {
            fg "#d9d7ce"
            bg "#212733"
            black "#191e2a"
            red "#f28779"
            green "#bae67e"
            yellow "#ffd580"
            blue "#73d0ff"
            magenta "#d4bfff"
            cyan "#95e6cb"
            white "#ffffff"
            orange "#ffad66"
        }
    }
  '';
  complement = "ayu-light";
}
