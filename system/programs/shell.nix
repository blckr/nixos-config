# fish as login shell; its user config and direnv are in home/programs/shell.nix
{
  ...
}:
{
  programs.fish.enable = true;

  documentation.dev.enable = true;

  # fish enables this by default; generating the cache slows down rebuilds
  documentation.man.cache.enable = false;
}
