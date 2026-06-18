# modules/desktop/xdg-portal.nix
{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.modules.desktop.enable {
  xdg.portal = {
    enable = true;

    # All backends for every active DE live here — no duplication across modules
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    config = {
      # Activated when XDG_CURRENT_DESKTOP=KDE
      KDE = {
        default = [ "kde" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "kde" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "kde" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "kde" ];
        "org.freedesktop.impl.portal.GlobalShortcuts" = [ "kde" ];
      };

      # Activated when XDG_CURRENT_DESKTOP=niri
      niri = lib.mkForce {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Camera" = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };

      # Neutral fallback for any future DE or unknown session
      common.default = [ "gtk" ];
    };
  };
}
