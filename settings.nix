# Werte, die System (NixOS) und home-manager gemeinsam nutzen.
# Kommt als `settings` über specialArgs bzw. extraSpecialArgs in jedes Modul.
{
  wallpaper = ./assets/wallpapers/nordic-outpost.png;

  # EurKEY, wie auf dem Mac: AltGr+a/o/u/s = ä/ö/ü/ß
  keyboard = {
    layout = "eu";
    variant = "";
    options = "caps:none";
  };
}
