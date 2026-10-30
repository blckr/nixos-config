# Keybindings werden einmal in Mac-Notation geschrieben und für Linux übersetzt
# (siehe docs/keybindings.md):
#   cmd+shift+X, cmd+alt+X  ->  ctrl+shift+alt+X
#   cmd+X                   ->  ctrl+shift+X
{ lib }:
rec {
  toLinux = lib.replaceStrings [ "cmd+shift+" "cmd+alt+" "cmd+" ] [
    "ctrl+shift+alt+"
    "ctrl+shift+alt+"
    "ctrl+shift+"
  ];

  # Doppelt belegte Tasten in einer Liste von { key, action }
  collisions =
    binds:
    let
      keys = map (b: b.key) binds;
    in
    lib.filter (k: lib.count (x: x == k) keys > 1) (lib.unique keys);

  # shared: Mac-Notation, wird auf Linux übersetzt
  # platform: bereits in der Notation der Zielplattform
  # Ergebnis: Ghostty-`keybind`-Liste, beginnt mit "clear" (keine versteckten Defaults)
  ghostty =
    {
      shared,
      platform ? { },
      isDarwin,
    }:
    let
      translate = if isDarwin then lib.id else toLinux;
      binds =
        lib.mapAttrsToList (key: action: {
          key = translate key;
          inherit action;
        }) shared
        ++ lib.mapAttrsToList (key: action: { inherit key action; }) platform;
      dups = collisions binds;
    in
    assert lib.assertMsg (dups == [ ]) "Ghostty-Keybinding-Kollision: ${toString dups}";
    [ "clear" ] ++ map (b: "${b.key}=${b.action}") binds;
}
