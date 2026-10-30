{ pkgs, ... }:
{
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 18;
    gtk.enable = true;
  };
}
