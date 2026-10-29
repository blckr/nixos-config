# Setting for the shell
{
  ...
}:
{
  programs.fish.enable = true;

  programs.direnv.enable = true;
  programs.direnv.silent = true;

  documentation.dev.enable = true;

  # fish aktiviert den man-Cache per mkDefault; der Build dauert lange
  documentation.man.cache.enable = false;

  programs.fish = {
    interactiveShellInit = ''
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -gx MANROFFOPT "-c"
    '';
  };
}
