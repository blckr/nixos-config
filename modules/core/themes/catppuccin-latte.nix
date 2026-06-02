{ pkgs }: {
  # Catppuccin Latte
  variant = "light";
  opacity = "0.95";
  colors = {
    bg = "eff1f5";
    bg_alt = "e6e9ef";
    fg = "4c4f69";
    accent = "8839ef";
    red = "d20f39";
    green = "40a02b";
    yellow = "df8e1d";
    blue = "1e66f5";
    magenta = "ea76cb";
    cyan = "179287";
    gray = "8c8fa1";
  };
  ui_colors = {
    bg = "24273a";
    bg_alt = "1e2030";
    fg = "cad3f5";
    accent = "c6a0f6";
    red = "ed8796";
    green = "a6da95";
    yellow = "eed49f";
    blue = "8aadf4";
    magenta = "f5bde6";
    cyan = "8bd5ca";
    gray = "5b6078";
  };
  wallpaper = ./../../../pkgs/wallpaper/DarkSpace.png;
  helix-theme = "catppuccin_latte";
  kitty-theme = "Catppuccin-Latte";
  gtk = {
    name = "Colloid-Light-Catppuccin";
    package = pkgs.colloid-gtk-theme.override {
      themeVariants = [ "default" ];
      colorVariants = [ "light" ];
      tweaks = [ "catppuccin" "rimless" ];
    };
    icons = "Colloid-Light";
    iconPackage = pkgs.colloid-icon-theme;
  };
  fish = ''
    set -U fish_color_normal 4c4f69
    set -U fish_color_command 1e66f5
    set -U fish_color_quote 40a02b
    set -U fish_color_redirection ea76cb
    set -U fish_color_end d20f39
    set -U fish_color_error d20f39
    set -U fish_color_param 4c4f69
    set -U fish_color_comment 8c8fa1
    set -U fish_color_selection --background=ccd0da
    set -U fish_color_search_match --background=ccd0da
    set -U fish_color_operator 8839ef
    set -U fish_color_escape ea76cb
    set -U fish_color_autosuggestion 8c8fa1
  '';
  zellij = ''
    theme "catppuccin-latte"
    themes {
        catppuccin-latte {
            bg "#eff1f5"
            fg "#4c4f69"
            black "#e6e9ef"
            red "#d20f39"
            green "#40a02b"
            yellow "#df8e1d"
            blue "#1e66f5"
            magenta "#ea76cb"
            cyan "#179287"
            white "#4c4f69"
            orange "#fe640b"
        }
    }
  '';
  complement = "catppuccin-macchiato";
}
