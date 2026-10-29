{ username, ... }:
{
  home-manager.users.${username} =
    { ... }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          font-size = 12;
          cursor-style = "block";
          window-padding-x = 4;
          window-padding-y = 4;
          confirm-close-surface = false;
          theme = "Nord";
        };
      };
    };
}
