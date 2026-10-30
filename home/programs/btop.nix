# BTOP is a modern system monitor
{
  lib,
  pkgs,
  settings,
  ...
}:
let
  theme = (import ../themes.nix { inherit pkgs; }).${settings.theme};
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = lib.mkDefault theme.dark.btop;
      theme_background = false;
      truecolor = true;
    };
  };
}
