# Nur Mac (eigenständiges home-manager auf dem Arbeitslaptop).
# Bewusst klein: keine Systemeingriffe, nur Dateien in ~.
{ pkgs, ... }:
{
  programs.ghostty.package = pkgs.ghostty-bin;

  # fish schaltet Man-Caches ein, auf dem Mac gibt es dafür kein man-Paket
  programs.man.generateCaches = false;

  programs.helix.settings.keys.normal.space.t = ":sh open -na Ghostty";

  # Identität (Name, Arbeits-E-Mail) steht lokal in ~/.gitconfig.local, nicht im Repo
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
