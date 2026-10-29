# --> Find File Type
# file --mime-type -b mein_dokument.pdf
# --> Find available Programs
# ls /run/current-system/sw/share/applications/
{ username, ... }:
{
  # Desktop-Einträge mit Terminal=true (z.B. Helix) in Ghostty öffnen
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };

  home-manager.users.${username} =
    { config, ... }:
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.gnome.Papers.desktop";
          "text/plain" = "Helix.desktop";
          "text/x-c" = "Helix.desktop";
        };
      };
    };
}
