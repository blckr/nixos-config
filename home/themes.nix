# Colour themes, each with a dark and a light variant. The default is
# `settings.theme`; `kit theme NAME` and `kit light|dark` switch at runtime.
{ pkgs }:
let
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
    noctalia = "Nord";
    dark = {
      ghostty = "Nord";
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
        name = "Nordic-Polar";
        package = pkgs.nordic;
      };
      gtk4 = true;
      icons = "Papirus-Light";
      # Kvantum-Nordic only exists in dark
      kvantum = nordicKvantum;
      # Nordic-Polar keeps the dark Nordic menubar and titlebar (#2b313c). Firefox
      # paints its vertical tab bar in the GTK menubar colour (with
      # browser.tabs.inTitlebar = 0), so give both the light Polar tones.
      gtk3Css = ''
        menubar, headerbar, .titlebar {
          background: #d8dee9;
          color: #3b4252;
        }
      '';
    };
  };

  # ayu-theme-gtk has no GTK4 variant and no Mirage, so GTK4 apps use Adwaita
  # and GTK3 apps Ayu-Dark.
  # There is no Ayu Kvantum theme, Qt apps keep Nordic.
  ayu = {
    noctalia = "Ayu";
    dark = {
      # Ayu Mirage where available. btop's "ayu" is Ayu Dark, TTY uses the
      # terminal's (Mirage) colours. GTK and noctalia only ship Ayu Dark.
      ghostty = "Ayu Mirage";
      btop = "TTY";
      # Selection derived from Ayu's selection blue
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
    noctalia = "Catppuccin";
    dark = catppuccin "mocha" // {
      ghostty = "Catppuccin Mocha";
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
}
