{
  lib,
  pkgs,
  settings,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  theme = (import ../../themes { inherit pkgs; }).${settings.theme};
  binds = import ./keybinds.nix;
  keybindings = import ../../../lib/keybindings.nix { inherit lib; };
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      cursor-style = "block";
      window-padding-x = 4;
      window-padding-y = 4;
      confirm-close-surface = false;
      # Follows the system (GNOME color-scheme or macOS appearance)
      theme = lib.mkDefault "light:${theme.light.ghostty},dark:${theme.dark.ghostty}";

      # Left Option = Alt (helix), right Option = EurKEY umlauts, like Alt/AltGr on Linux
      macos-option-as-alt = "left";

      keybind = keybindings.ghostty {
        inherit isDarwin;
        inherit (binds) shared;
        platform = binds.common // (if isDarwin then binds.darwin else binds.linux);
      };
    };
  };
}
