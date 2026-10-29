{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.apps.docker;
in
{
  options.modules.apps.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    # Startet erst beim ersten docker-Aufruf (Socket-Aktivierung)
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };

    # Erlaubt dem Benutzer, Docker ohne sudo zu nutzen.
    # Hinweis: Gruppenänderung wird erst nach erneutem Login (oder `newgrp docker`) aktiv.
    users.users.${username}.extraGroups = [ "docker" ];
  };
}
