# Values shared by the system (NixOS) and home-manager.
# Passed to every module as `settings` via specialArgs / extraSpecialArgs.
{
  wallpaper = ./assets/wallpapers/nordic-outpost.png;

  # EurKEY, same as on the Mac: AltGr+a/o/u/s = ä/ö/ü/ß
  keyboard = {
    layout = "eu";
    variant = "";
    options = "caps:none";
  };
}
