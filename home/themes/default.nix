{ pkgs }:
let
  everforest = import ./everforest.nix;
  wallpapers = import ./wallpapers.nix;
  # Nordic-Polar has a dark menubar, and Firefox paints its vertical tab bar in that colour.
  # Fixed in the theme because gtk.css is only read at startup.
  nordicPolarLight =
    pkgs.runCommand "nordic-polar-light" { } ''
      theme=$out/share/themes/Nordic-Polar-Light
      mkdir -p $out/share/themes
      cp -r ${pkgs.nordic}/share/themes/Nordic-Polar $theme
      chmod -R u+w $theme
      sed -i 's/^Name=.*/Name=Nordic-Polar-Light/' $theme/index.theme
      for css in $theme/gtk-3.0/gtk.css $theme/gtk-4.0/gtk.css; do
        cat >> $css <<'CSS'

      menubar, headerbar, .titlebar {
        background: #d8dee9;
        color: #3b4252;
      }
      CSS
      done
    '';

  nordicKvantum = {
    name = "Nordic";
    package = pkgs.nordic;
  };
  catppuccinBtop =
    variant:
    "${
      pkgs.catppuccin.override {
        inherit variant;
        themeList = [ "btop" ];
      }
    }/btop/catppuccin_${variant}.theme";
  catppuccin = variant: {
    btop = catppuccinBtop variant;
    gtk = {
      name = "catppuccin-${variant}-blue-standard";
      package = pkgs.catppuccin-gtk.override { inherit variant; };
    };
    kvantum = {
      name = "catppuccin-${variant}-blue";
      package = pkgs.catppuccin-kvantum.override { inherit variant; };
    };
  };
in
{
  nord = {
    wallpaper = wallpapers.nord;
    noctalia = {
      source = "builtin";
      builtin = "Nord";
    };
    dark = {
      ghostty = "Nord";
      helix = "nord";
      btop = "nord";
      walker = {
        bg = "#2e3440";
        fg = "#eceff4";
        accent = "#8fbcbb";
        selection = "#4c566a";
        border = "#4c566a";
      };
      gtk = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      gtk4 = true;
      icons = "Papirus-Dark";
      kvantum = nordicKvantum;
    };
    light = {
      ghostty = "Nord Light";
      helix = "nord_light";
      # btop has no light Nord theme; TTY uses the terminal's 16 colours
      btop = "TTY";
      walker = {
        bg = "#e5e9f0";
        fg = "#414858";
        accent = "#5e81ac";
        selection = "#d8dee9";
        border = "#d8dee9";
      };
      gtk = {
        name = "Nordic-Polar-Light";
        package = nordicPolarLight;
      };
      gtk4 = true;
      icons = "Papirus-Light";
      # Kvantum-Nordic only exists in dark
      kvantum = nordicKvantum;
    };
  };

  # ayu-theme-gtk has no GTK4 variant and no Mirage; no Ayu Kvantum theme, Qt keeps Nordic
  ayu = {
    wallpaper = wallpapers.ayu;
    # noctalia only ships Ayu Dark, so Mirage comes from our own palette
    noctalia = {
      source = "custom";
      custom_palette = "AyuMirage";
    };
    noctaliaPalette = import ./ayu-mirage-noctalia.nix;
    dark = {
      # btop's "ayu" is Ayu Dark, TTY uses the terminal's Mirage colours
      ghostty = "Ayu Mirage";
      helix = "ayu_mirage";
      btop = "TTY";
      walker = {
        bg = "#1f2430";
        fg = "#cccac2";
        accent = "#ffcc66";
        selection = "alpha(#409fff, 0.3)";
        border = "alpha(#409fff, 0.3)";
      };
      gtk = {
        name = "Ayu-Dark";
        package = pkgs.ayu-theme-gtk;
      };
      gtk4 = false;
      icons = "Papirus-Dark";
      kvantum = nordicKvantum;
    };
    light = {
      ghostty = "Ayu Light";
      helix = "ayu_light";
      btop = "TTY";
      walker = {
        bg = "#f8f9fa";
        fg = "#5c6166";
        accent = "#ffaa33";
        selection = "alpha(#035bd6, 0.15)";
        border = "alpha(#035bd6, 0.15)";
      };
      gtk = {
        name = "Ayu";
        package = pkgs.ayu-theme-gtk;
      };
      gtk4 = false;
      icons = "Papirus-Light";
      kvantum = nordicKvantum;
    };
  };

  catppuccin = {
    wallpaper = wallpapers.catppuccin;
    noctalia = {
      source = "builtin";
      builtin = "Catppuccin";
    };
    dark = catppuccin "mocha" // {
      ghostty = "Catppuccin Mocha";
      helix = "catppuccin_mocha";
      walker = {
        bg = "#1e1e2e";
        fg = "#cdd6f4";
        accent = "#89b4fa";
        selection = "#585b70";
        border = "#585b70";
      };
      gtk4 = true;
      icons = "Papirus-Dark";
    };
    light = catppuccin "latte" // {
      ghostty = "Catppuccin Latte";
      helix = "catppuccin_latte";
      walker = {
        bg = "#eff1f5";
        fg = "#4c4f69";
        accent = "#1e66f5";
        selection = "#acb0be";
        border = "#acb0be";
      };
      gtk4 = true;
      icons = "Papirus-Light";
    };
  };

  # No Everforest Kvantum theme, Qt apps keep Nordic
  everforest = {
    wallpaper = wallpapers.everforest;
    noctalia = {
      source = "custom";
      custom_palette = "Everforest";
    };
    noctaliaPalette = everforest.noctaliaPalette;
    ghosttyThemes = everforest.ghosttyThemes;
    dark = {
      ghostty = "everforest-dark-medium";
      helix = "everforest_dark";
      btop = "everforest-dark-medium";
      walker = everforest.walker.dark;
      gtk = {
        name = "Everforest-Dark";
        package = pkgs.everforest-gtk-theme;
      };
      gtk4 = true;
      icons = "Papirus-Dark";
      kvantum = nordicKvantum;
    };
    light = {
      ghostty = "everforest-light-medium";
      helix = "everforest_light";
      btop = "everforest-light-medium";
      walker = everforest.walker.light;
      gtk = {
        name = "Everforest-Light";
        package = pkgs.everforest-gtk-theme;
      };
      gtk4 = true;
      icons = "Papirus-Light";
      kvantum = nordicKvantum;
    };
  };
}
