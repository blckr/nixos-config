{
  pkgs,
  username,
  config,
  ...
}:
let
  themeData = config.modules.theme.data;
in
{
  home-manager.users.${username} =
    { ... }:
    {
      gtk = {
        enable = true;
        theme.name = themeData.gtk.name;
        theme.package = themeData.gtk.package;

        iconTheme.name = themeData.gtk.icons;
        iconTheme.package = themeData.gtk.iconPackage;

        gtk4.extraConfig = {
          gtk-theme-name = themeData.gtk.name;
        };
      };

      # Libadwaita / GTK4 support
      xdg.configFile."gtk-4.0/gtk.css".source = "${themeData.gtk.package}/share/themes/${themeData.gtk.name}/gtk-4.0/gtk.css";
      xdg.configFile."gtk-4.0/gtk-dark.css".source = "${themeData.gtk.package}/share/themes/${themeData.gtk.name}/gtk-4.0/gtk-dark.css";
      xdg.configFile."gtk-4.0/assets".source = "${themeData.gtk.package}/share/themes/${themeData.gtk.name}/gtk-4.0/assets";

      home.file.".themes".source = "${config.system.path}/share/themes";

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = if themeData.variant == "light" then "prefer-light" else "prefer-dark";
        };
      };
    };
}
