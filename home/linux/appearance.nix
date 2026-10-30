# Light variant as a home-manager specialisation, toggled with `kit light` / `kit dark`.
# Dark is the regular configuration. Ghostty, Firefox and libadwaita follow color-scheme on their own.
{ lib, ... }:
{
  specialisation.light.configuration = {
    gtk.theme.name = lib.mkForce "Nordic-Polar";
    gtk.iconTheme.name = lib.mkForce "Papirus-Light";
    # Nordic-Polar keeps the dark Nordic menubar and titlebar (#2b313c). Firefox
    # paints its vertical tab bar in the GTK menubar colour (with
    # browser.tabs.inTitlebar = 0), so give both the light Polar tones.
    gtk.gtk3.extraCss = ''
      menubar, headerbar, .titlebar {
        background: #d8dee9;
        color: #3b4252;
      }
    '';
    dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-light";
    # noctalia writes color-scheme itself (sync_color_scheme), so switch it as well
    programs.noctalia.settings.theme.mode = lib.mkForce "light";
  };
}
