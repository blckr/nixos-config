# Light variant as a home-manager specialisation, toggled with `kit light` / `kit dark`.
# Dark is the regular configuration. Ghostty, Firefox and libadwaita follow color-scheme on their own.
{ lib, ... }:
{
  specialisation.light.configuration = {
    gtk.theme.name = lib.mkForce "Nordic-Polar";
    gtk.iconTheme.name = lib.mkForce "Papirus-Light";
    dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-light";
    # noctalia writes color-scheme itself (sync_color_scheme), so switch it as well
    programs.noctalia.settings.theme.mode = lib.mkForce "light";
  };
}
