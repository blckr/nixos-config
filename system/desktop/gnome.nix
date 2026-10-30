{ config, lib, ... }:
lib.mkIf config.modules.desktop.enable {
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
}
