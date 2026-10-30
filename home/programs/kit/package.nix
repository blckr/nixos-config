# The kit script as a package. Also used by lib/checks.nix to test the Mac
# variant on Linux.
{
  pkgs,
  lib,
  platform,
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
in
pkgs.writeShellApplication {
  name = "kit";
  runtimeInputs = [ pkgs.coreutils ];
  text =
    lib.replaceStrings
      [ "@platform@" "@host@" "@user@" "@flake@" "@keys@" "@theme@" "@themes@" ]
      [ platform host user flake "${keysDir}" theme (toString themes) ]
      (builtins.readFile ./kit.sh);
}
