# GNOME-Session: Layout und Hintergrund wie unter niri
{ lib, settings, ... }:
let
  wallpaper = "file://${settings.wallpaper}";
in
{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" settings.keyboard.layout ]) ];
      xkb-options = [ settings.keyboard.options ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = wallpaper;
      picture-uri-dark = wallpaper;
      picture-options = "zoom"; # entspricht noctalias fill_mode "crop"
    };
    "org/gnome/desktop/screensaver".picture-uri = wallpaper;
  };
}
