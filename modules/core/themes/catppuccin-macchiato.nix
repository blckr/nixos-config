{ pkgs }: {
  # Catppuccin Macchiato
  variant = "dark";
  opacity = "0.9";
  colors = {
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
  helix-theme = "catppuccin_macchiato";
  kitty-theme = "Catppuccin-Macchiato";
  gtk = {
    name = "Colloid-Dark-Catppuccin";
    package = pkgs.colloid-gtk-theme.override {
      themeVariants = [ "default" ];
      colorVariants = [ "dark" ];
      tweaks = [ "catppuccin" "rimless" ];
    };
    icons = "Colloid-Dark";
    iconPackage = pkgs.colloid-icon-theme;
  };
  fish = ''
    set -U fish_color_normal cad3f5
    set -U fish_color_command 8aadf4
    set -U fish_color_quote a6da95
    set -U fish_color_redirection f5bde6
    set -U fish_color_end ed8796
    set -U fish_color_error ed8796
    set -U fish_color_param cad3f5
    set -U fish_color_comment 5b6078
    set -U fish_color_selection --background=363a4f
    set -U fish_color_search_match --background=363a4f
    set -U fish_color_operator c6a0f6
    set -U fish_color_escape f5bde6
    set -U fish_color_autosuggestion 5b6078
  '';
  zellij = ''
    theme "catppuccin-macchiato"
    themes {
        catppuccin-macchiato {
            bg "#24273a"
            fg "#cad3f5"
            black "#1e2030"
            red "#ed8796"
            green "#a6da95"
            yellow "#eed49f"
            blue "#8aadf4"
            magenta "#f5bde6"
            cyan "#8bd5ca"
            white "#cad3f5"
            orange "#f5a97f"
        }
    }
  '';
  complement = "catppuccin-latte";
}
