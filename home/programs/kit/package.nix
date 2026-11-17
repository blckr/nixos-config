# Also used by lib/checks.nix to test the Mac variant on Linux
{
  pkgs,
  lib,
  platform,
  systemType,
  host,
  user,
  flake,
  keys,
  theme,
  themes,
}:
let
  keysDir = pkgs.linkFarm "kit-keys" (
    lib.mapAttrsToList (name: text: {
      name = "${name}.txt";
      path = pkgs.writeText "kit-keys-${name}.txt" text;
    }) keys
  );

  script = pkgs.writeShellApplication {
    name = "kit";
    runtimeInputs = [ pkgs.coreutils ];
    text =
      lib.replaceStrings
        [ "@platform@" "@systemType@" "@host@" "@user@" "@flake@" "@keys@" "@theme@" "@themes@" ]
        [ platform systemType host user flake "${keysDir}" theme (toString themes) ]
        (builtins.readFile ./kit.sh);
  };

  completions = pkgs.writeTextDir "share/fish/vendor_completions.d/kit.fish" (
    lib.replaceStrings
      [ "@targets@" "@keys@" "@themes@" ]
      [
        (if systemType == "none" then "home" else "system home")
        (toString (lib.attrNames keys))
        (toString themes)
      ]
      (builtins.readFile ./kit.fish)
  );
in
pkgs.symlinkJoin {
  name = "kit";
  paths = [
    script
    completions
  ];
}
