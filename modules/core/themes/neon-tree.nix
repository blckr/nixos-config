{ pkgs }:
{
  # Neon Tree
  variant = "dark";
  opacity = "0.85"; # Etwas transparenter, damit der Baum besser wirkt
  colors = {
    bg = "121414";
    bg_alt = "1a1c1c";
    fg = "d1d1d1";
    accent = "b8d182";
    red = "e67e80";
    green = "b8d182";
    yellow = "dbbc7f";
    blue = "7fbbb3";
    magenta = "d699b6";
    cyan = "83c092";
    gray = "5c6370";
  };
  ui_colors = {
    bg = "121414";
    bg_alt = "1a1c1c";
    fg = "b8d182";
    accent = "b8d182";
    red = "e67e80";
    green = "b8d182";
    yellow = "dbbc7f";
    blue = "7fbbb3";
    magenta = "d699b6";
    cyan = "83c092";
    gray = "5c6370";
  };
  wallpaper = ./../../../pkgs/wallpaper/BlackGreenTree.jpg;
  helix-theme = "sunset";
  kitty-theme = "Custom"; # Wird durch unsere Config generiert
  gtk = {
    name = "Colloid-Dark-Green";
    package = pkgs.colloid-gtk-theme.override {
      themeVariants = [ "default" ];
      colorVariants = [ "dark" ];
      tweaks = [
        "everforest"
        "rimless"
      ];
    };
    icons = "Papirus-Dark";
    iconPackage = pkgs.papirus-icon-theme;
  };
  fish = ''
    set -U fish_color_normal e0e0e0
    set -U fish_color_command d1ff5e
    set -U fish_color_quote ecf024
    set -U fish_color_redirection cf5fdf
    set -U fish_color_end ff5f5f
    set -U fish_color_error ff5f5f
    set -U fish_color_param e0e0e0
    set -U fish_color_comment 404040
    set -U fish_color_selection --background=202020
    set -U fish_color_search_match --background=202020
    set -U fish_color_operator d1ff5e
    set -U fish_color_escape cf5fdf
    set -U fish_color_autosuggestion 404040
  '';
  zellij = ''
    theme "neon-tree"
    themes {
        neon-tree {
            fg "#e0e0e0"
            bg "#000000"
            black "#0a0a0a"
            red "#ff5f5f"
            green "#d1ff5e"
            yellow "#ecf024"
            blue "#5fbfff"
            magenta "#cf5fdf"
            cyan "#5fdfcf"
            white "#ffffff"
            orange "#ffa500"
        }
    }
  '';
}
