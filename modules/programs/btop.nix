# BTOP is a modern system monitor
{ username, ... }:

{
  home-manager.users.${username} =
    { config, ... }:
    {

      programs.btop = {
        enable = true;
      };

    };
}
