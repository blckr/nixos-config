{ lib, config, ... }:
{
  options.modules.desktop = {
    enable = lib.mkEnableOption "Enable the desktop environment suite (Niri and GNOME)";
  };

  imports = [
    ./fonts.nix
    ./opengl.nix
    ./qt.nix
    ./xdg-desktop-portal.nix

    ./niri
    ./gnome.nix
  ];
}
