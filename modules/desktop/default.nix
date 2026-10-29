{ lib, config, ... }:
{
  options.modules.desktop = {
    enable = lib.mkEnableOption "Enable the desktop environment suite (Niri and GNOME)";
  };

  imports = [
    ./cursor.nix
    ./fonts.nix
    ./gtk.nix
    ./opengl.nix
    ./qt.nix
    ./xdg-desktop-portal.nix

    ./niri
    ./gnome
  ];
}
