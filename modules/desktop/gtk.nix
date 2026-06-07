{
  pkgs,
  username,
  config,
  ...
}:
{
  environment.systemPackages = [
    pkgs.adw-gtk3
  ];

  home-manager.users.${username} =
    { ... }:
    {
      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk3.extraCss = ''
          @import url("noctalia.css");
        '';
        gtk4.extraCss = ''
          @import url("file://${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark/gtk-4.0/gtk.css");
          @import url("noctalia.css");
        '';
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
        };
      };

      home.file.".themes".source = "${config.system.path}/share/themes";
      xdg.dataFile."themes".source = "${config.system.path}/share/themes";
    };
}
