# Keybinding tables for `kit keys`, generated from the same data as the bindings themselves
{
  lib,
  config,
  isDarwin,
}:
let
  pad = width: s: s + lib.concatStrings (lib.genList (_: " ") (width - lib.stringLength s));

  table =
    rows:
    let
      width = lib.foldl' lib.max 0 (map (r: lib.stringLength (lib.head r)) rows);
    in
    lib.concatMapStrings (r: "${pad width (lib.head r)}  ${lib.last r}\n") rows;

  ghostty = lib.concatMap (
    b:
    let
      m = builtins.match "(performable:)?([^=]+)=(.*)" b;
    in
    lib.optional (m != null) [
      (lib.elemAt m 1)
      (lib.elemAt m 2)
    ]
  ) config.programs.ghostty.settings.keybind;

  # A bind line in niri: `Mod+E { spawn "ghostty"; }`
  niriText = config.home.file.".config/niri/config.kdl".text or null;
  niri =
    let
      lines = lib.splitString "\n" niriText;
      # Lines between `binds {` and its closing brace (binds are single-line)
      inBinds = lib.foldl' (
        acc: l:
        if builtins.match " *binds \\{ *" l != null then
          acc // { on = true; }
        else if acc.on && builtins.match " *} *" l != null then
          acc // { on = false; }
        else if acc.on then
          acc // { rows = acc.rows ++ [ l ]; }
        else
          acc
      ) { on = false; rows = [ ]; } lines;
    in
    lib.concatMap (
      l:
      let
        m = builtins.match " *([^ /{][^ {]*)[^{]*\\{ *(.*[^ ]) *} *" l;
      in
      lib.optional (m != null) [
        (lib.head m)
        (lib.removeSuffix ";" (lib.last m))
      ]
    ) inBinds.rows;

  # GNOME: dconf values are GVariant objects, the strings live in `.value`
  strings =
    v:
    if builtins.isAttrs v && v ? value then
      strings v.value
    else if builtins.isList v then
      lib.concatMap strings v
    else
      [ (toString v) ];
  dconf = config.dconf.settings or { };
  gnomeSchemas = [
    "org/gnome/desktop/wm/keybindings"
    "org/gnome/shell/keybindings"
    "org/gnome/settings-daemon/plugins/media-keys"
  ];
  gnome =
    lib.concatMap (
      path:
      lib.mapAttrsToList (key: v: [
        (if strings v == [ ] then "(off)" else lib.concatStringsSep " " (strings v))
        key
      ]) (lib.filterAttrs (k: _: k != "custom-keybindings") (dconf.${path} or { }))
    ) gnomeSchemas
    ++ lib.mapAttrsToList (_: c: [
      (lib.concatStrings (strings c.binding))
      "${lib.concatStrings (strings c.name)}: ${lib.concatStrings (strings c.command)}"
    ]) (lib.filterAttrs (p: _: lib.hasPrefix "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/" p) dconf);
  browser =
    name:
    table (
      map (b: [
        b.${name}
        b.action
      ]) (lib.filter (b: b.${name} != null) (import ./browser.nix))
    );
in
{
  ghostty = table ghostty;
}
// lib.optionalAttrs (config.modules.apps.firefox.enable or false) { firefox = browser "firefox"; }
// lib.optionalAttrs isDarwin { chrome = browser "chrome"; }
// lib.optionalAttrs (niriText != null) { niri = table niri; }
// lib.optionalAttrs (gnome != [ ]) { gnome = table gnome; }
