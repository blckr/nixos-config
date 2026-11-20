# Mac: standalone home-manager or through nix-darwin
{
  config,
  lib,
  pkgs,
  settings,
  ...
}:
let
  themes = import ../themes { inherit pkgs; };
  # kit sets the desktop picture from these, see setWallpaper in kit.sh
  wallpapers = theme: {
    "wallpapers/light".source = theme.wallpaper.light;
    "wallpapers/dark".source = theme.wallpaper.dark;
  };
in
{
  # Only Ghostty, btop, helix and the wallpaper are themed; Ghostty and helix follow the macOS appearance
  specialisation = lib.mapAttrs (_: theme: {
    configuration = {
      programs = {
        ghostty.settings.theme = lib.mkForce "light:${theme.light.ghostty},dark:${theme.dark.ghostty}";
        # btop cannot follow the macOS appearance, so it uses the dark variant
        btop.settings.color_theme = lib.mkForce theme.dark.btop;
        helix.settings.theme = lib.mkForce {
          dark = theme.dark.helix;
          light = theme.light.helix;
        };
      };
      xdg.dataFile = lib.mapAttrs (_: lib.mapAttrs (_: lib.mkForce)) (wallpapers theme);
    };
  }) (lib.removeAttrs themes [ settings.theme ]);

  xdg.dataFile = wallpapers themes.${settings.theme};

  programs.ghostty.package = pkgs.ghostty-bin;
  # The macOS login shell stays zsh; on NixOS fish is the default user shell
  programs.ghostty.settings.command = lib.getExe config.programs.fish.package;

  # On NixOS this comes from system/programs/shell.nix
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
  # Reloaded by kit (reloadGhostty), the macOS app ignores SIGUSR2

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
