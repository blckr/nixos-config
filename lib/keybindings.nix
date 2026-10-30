# Keybindings are written once in Mac notation and translated for Linux
# (see docs/keybindings.md):
#   cmd+shift+X, cmd+alt+X  ->  ctrl+shift+alt+X
#   cmd+X                   ->  ctrl+shift+X
{ lib }:
rec {
  toLinux = lib.replaceStrings [ "cmd+shift+" "cmd+alt+" "cmd+" ] [
    "ctrl+shift+alt+"
    "ctrl+shift+alt+"
    "ctrl+shift+"
  ];

  # Keys bound more than once in a list of { key, action }
  collisions =
    binds:
    let
      keys = map (b: b.key) binds;
    in
    lib.filter (k: lib.count (x: x == k) keys > 1) (lib.unique keys);

  # shared: Mac notation, translated on Linux
  # platform: already in the notation of the target platform
  # Result: Ghostty `keybind` list, starting with "clear" (no hidden defaults)
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
    assert lib.assertMsg (dups == [ ]) "Ghostty keybinding collision: ${toString dups}";
    [ "clear" ] ++ map (b: "${b.key}=${b.action}") binds;
}
