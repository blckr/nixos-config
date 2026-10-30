# GNOME session: layout, wallpaper and system shortcuts matching niri and the Mac
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

    # System level like on the Mac (Cmd -> Super), see docs/keybindings.md
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" "<Alt>F4" ];
      minimize = [ "<Super>m" "<Super>h" ];
      toggle-fullscreen = [ "<Super><Control>f" ];
      # Super+Space is search; there is only one layout
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      # Ctrl+Alt(+Shift)+arrows belong to Ghostty (split navigation)
      switch-to-workspace-left = [ "<Super>Page_Up" "<Super><Alt>Left" ];
      switch-to-workspace-right = [ "<Super>Page_Down" "<Super><Alt>Right" ];
      switch-to-workspace-up = [ ];
      switch-to-workspace-down = [ ];
      move-to-workspace-left = [ "<Super><Shift>Page_Up" "<Super><Shift><Alt>Left" ];
      move-to-workspace-right = [ "<Super><Shift>Page_Down" "<Super><Shift><Alt>Right" ];
      move-to-workspace-up = [ ];
      move-to-workspace-down = [ ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-overview = [ "<Super>space" ];
      screenshot = [ "<Shift>Print" "<Super><Shift>3" ];
      show-screenshot-ui = [ "Print" "<Super><Shift>4" "<Super><Shift>5" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      # Super+L is "focus right" in niri and must not lock the screen here
      screensaver = [ "<Super><Control>q" ];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Super>e";
    };
  };
}
