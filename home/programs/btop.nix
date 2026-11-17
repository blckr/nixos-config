{
  lib,
  pkgs,
  settings,
  ...
}:
let
  theme = (import ../themes { inherit pkgs; }).${settings.theme};
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
