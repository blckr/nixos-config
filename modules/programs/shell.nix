# Setting for the shell
{
  pkgs, username, config, ...
}:
{
  programs.fish.enable = true;

  programs.direnv.enable = true;
  programs.direnv.silent = true;

  documentation.dev.enable = true; #Documentation

  documentation = {
    man.enable = true;
    man.generateCaches = true;
  };

  programs.fish = {
    interactiveShellInit = ''
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -gx MANROFFOPT "-c"
      ${config.modules.theme.data.fish}
    '';
  };
}
