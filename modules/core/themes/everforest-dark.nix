{ pkgs }:
{
  # Everforest Dark
  variant = "dark";
  opacity = "0.9";
  colors = {
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
  helix-theme = "everforest_dark";
  kitty-theme = "Everforest Dark Hard";
  gtk = {
    name = "Everforest-Dark-BL";
    package = pkgs.everforest-gtk-theme;
    icons = "Adwaita";
    iconPackage = pkgs.adwaita-icon-theme;
  };
  fish = ''
    set -U fish_color_normal d3c6aa
    set -U fish_color_command a7c080
    set -U fish_color_quote dbbc7f
    set -U fish_color_redirection d3c6aa
    set -U fish_color_end e67e80
    set -U fish_color_error e67e80
    set -U fish_color_param d3c6aa
    set -U fish_color_comment 859289
    set -U fish_color_selection --background=4f5b58
    set -U fish_color_search_match --background=4f5b58
    set -U fish_color_operator dbbc7f
    set -U fish_color_escape d699b6
    set -U fish_color_autosuggestion 859289
  '';
  zellij = ''
    theme "everforest"
    themes {
        everforest {
            fg "#d3c6aa"
            bg "#2d353b"
            black "#232a2e"
            red "#e67e80"
            green "#a7c080"
            yellow "#dbbc7f"
            blue "#7fbbb3"
            magenta "#d699b6"
            cyan "#83c092"
            white "#d3c6aa"
            orange "#e69875"
            // High contrast selection
            // Content selection (High Contrast)
            text_selected {
                base "#2d353b"
                background "#d3c6aa"
                emphasis_0 "#a7c080"
                emphasis_1 "#dbbc7f"
                emphasis_2 "#7fbbb3"
                emphasis_3 "#d699b6"
            }
            // UI Components (Theme Aligned)
            ribbon_selected {
                base "#2d353b"
                background "#a7c080" // Accent Green instead of Cream
                emphasis_0 "#2d353b"
                emphasis_1 "#2d353b"
                emphasis_2 "#2d353b"
                emphasis_3 "#2d353b"
            }
            ribbon_unselected {
                base "#d3c6aa"
                background "#232a2e"
                emphasis_0 "#a7c080"
                emphasis_1 "#dbbc7f"
                emphasis_2 "#7fbbb3"
                emphasis_3 "#d699b6"
            }
            list_selected {
                base "#2d353b"
                background "#a7c080"
                emphasis_0 "#2d353b"
                emphasis_1 "#2d353b"
                emphasis_2 "#2d353b"
                emphasis_3 "#2d353b"
            }
            list_unselected {
                base "#d3c6aa"
                background "#2d353b"
                emphasis_0 "#a7c080"
                emphasis_1 "#dbbc7f"
                emphasis_2 "#7fbbb3"
                emphasis_3 "#d699b6"
            }
        }
    }
  '';
  complement = "everforest-light";
}
