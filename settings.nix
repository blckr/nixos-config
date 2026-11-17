# Shared by NixOS and home-manager, passed to every module as `settings`
{
  wallpaper = ./assets/wallpapers/nordic-outpost.png;

  # see home/themes
  theme = "nord";

  # EurKEY, same as on the Mac: AltGr+a/o/u/s = ä/ö/ü/ß
  keyboard = {
    layout = "eu";
    variant = "";
    options = "caps:none";
  };
}
