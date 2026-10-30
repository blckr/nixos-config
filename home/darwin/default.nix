# Mac only (standalone home-manager on the work laptop).
# Deliberately small: no system changes, only files in ~.
{ pkgs, ... }:
{
  programs.ghostty.package = pkgs.ghostty-bin;

  # fish enables man caches, but there is no man package on the Mac
  programs.man.generateCaches = false;

  programs.helix.settings.keys.normal.space.t = ":sh open -na Ghostty";

  # Identity (name, work email) lives locally in ~/.gitconfig.local, not in the repo
  programs.git = {
    enable = true;
    includes = [ { path = "~/.gitconfig.local"; } ];
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "hx";
    };
  };
}
