# Colour themes, each with a dark and a light variant. The default is
# `settings.theme`; `kit theme NAME` and `kit light|dark` switch at runtime.
{ pkgs }:
let
  nordicKvantum = {
    name = "Nordic";
    package = pkgs.nordic;
  };
  catppuccin = variant: {
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

  # ayu-theme-gtk has no GTK4 variant, so GTK4 apps use Adwaita there.
  # There is no Ayu Kvantum theme, Qt apps keep Nordic.
  ayu = {
    noctalia = "Ayu";
    dark = {
      ghostty = "Ayu";
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
      gtk4 = true;
      icons = "Papirus-Dark";
    };
    light = catppuccin "latte" // {
      ghostty = "Catppuccin Latte";
      gtk4 = true;
      icons = "Papirus-Light";
    };
  };
}
