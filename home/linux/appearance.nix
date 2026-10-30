# Theme and dark/light mode. The base configuration is `settings.theme` in dark;
# every other theme/mode combination is a home-manager specialisation named
# "<theme>-<mode>", activated by `kit theme NAME` and `kit light|dark`.
{
  config,
  lib,
  pkgs,
  settings,
  ...
}:
let
  themes = import ../themes { inherit pkgs; };
  modes = [
    "dark"
    "light"
  ];

  # Everything that changes with theme and mode
  apply =
    name: mode:
    let
      theme = themes.${name};
      variant = theme.${mode};
      qtct = ''
        [Appearance]
        style=kvantum
        icon_theme=${variant.icons}
        standard_dialogs=default

        [Interface]
        dialog_buttons_have_icons=1
        menus_have_icons=true
        toolbutton_style=4
      '';
    in
    {
      gtk.theme = variant.gtk;
      gtk.gtk4.theme = if variant.gtk4 then variant.gtk else null;
      gtk.iconTheme.name = variant.icons;
      gtk.gtk3.extraCss = variant.gtk3Css or "";
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-${mode}";
      # noctalia writes color-scheme itself (sync_color_scheme), so it must agree
      programs.noctalia.settings.theme = theme.noctalia // {
        inherit mode;
      };
      programs.helix.settings.theme = variant.helix;
      programs.ghostty.settings.theme = "light:${theme.light.ghostty},dark:${theme.dark.ghostty}";
      programs.btop.settings.color_theme = variant.btop;
      modules.desktop.walker.colors = variant.walker;
      xdg.configFile = lib.optionalAttrs (theme ? noctaliaPalette) {
        "noctalia/palettes/${theme.noctalia.custom_palette}.json".text =
          builtins.toJSON theme.noctaliaPalette;
      }
      // {
        "qt5ct/qt5ct.conf".text = qtct;
        "qt6ct/qt6ct.conf".text = qtct;
        "Kvantum/kvantum.kvconfig".text = ''
          [General]
          theme=${variant.kvantum.name}
        '';
        "Kvantum/${variant.kvantum.name}".source =
          "${variant.kvantum.package}/share/Kvantum/${variant.kvantum.name}";
      };
    };

  # Specialisations inherit the base configuration, so their values must win
  force = lib.mapAttrsRecursiveCond (as: !lib.isDerivation as) (_: lib.mkForce);

  base = "${settings.theme}-dark";
  variants = lib.filter (n: n != base) (
    lib.concatMap (name: map (mode: "${name}-${mode}") modes) (lib.attrNames themes)
  );
in
{
  config = lib.mkMerge [
    {
      # noctalia keeps settings changed in its GUI in this file, and they win over
      # config.toml. Only the declarative config counts, so drop it on activation.
      home.activation.dropNoctaliaOverrides = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f "${config.xdg.stateHome}/noctalia/settings.toml"
      '';
    }
    (apply settings.theme "dark")
    {
      specialisation = lib.genAttrs variants (
        v:
        let
          parts = lib.splitString "-" v;
        in
        {
          configuration = force (apply (lib.head parts) (lib.last parts));
        }
      );
    }
  ];
}
