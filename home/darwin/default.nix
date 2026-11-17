# Mac: standalone home-manager or through nix-darwin
{
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
  # Only Ghostty, btop, helix and the wallpaper are themed; Ghostty follows the macOS appearance
  specialisation = lib.mapAttrs (_: theme: {
    configuration = {
      programs = {
        ghostty.settings.theme = lib.mkForce "light:${theme.light.ghostty},dark:${theme.dark.ghostty}";
        # btop cannot follow the macOS appearance, so it uses the dark variant
        btop.settings.color_theme = lib.mkForce theme.dark.btop;
        helix.settings.theme = lib.mkForce theme.dark.helix;
      };
      xdg.dataFile = lib.mapAttrs (_: lib.mapAttrs (_: lib.mkForce)) (wallpapers theme);
    };
  }) (lib.removeAttrs themes [ settings.theme ]);

  xdg.dataFile = wallpapers themes.${settings.theme};

  programs.ghostty.package = pkgs.ghostty-bin;
  xdg.configFile."ghostty/config".onChange = ''
    /usr/bin/pkill -USR2 -u "$USER" -x ghostty || true
  '';

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
