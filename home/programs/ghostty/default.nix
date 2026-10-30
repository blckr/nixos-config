{ lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
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
      theme = "Nord";

      # Linke Option = Alt (helix), rechte Option = EurKEY-Umlaute, wie Alt/AltGr unter Linux
      macos-option-as-alt = "left";

      keybind = keybindings.ghostty {
        inherit isDarwin;
        inherit (binds) shared;
        platform = binds.common // (if isDarwin then binds.darwin else binds.linux);
      };
    };
  };
}
