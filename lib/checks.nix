# `nix flake check`: keybinding translation, kit, appearance and Ghostty configs of both platforms
{
  self,
  pkgs,
  lib,
}:
let
  keybindings = import ./keybindings.nix { inherit lib; };
  binds = import ../home/programs/ghostty/keybinds.nix;
  browserKeys = import ../home/programs/kit/browser.nix;

  # Ghostty settings of a Mac as a config file, written with Linux pkgs
  # (no Darwin builder needed)
  renderGhostty =
    name: settings:
    pkgs.writeText "ghostty-${name}.conf" (
      lib.concatStrings (
        lib.mapAttrsToList (
          key: values: lib.concatMapStrings (v: "${key} = ${lib.generators.mkValueStringDefault { } v}\n") values
        ) settings
      )
    );
  darwinSystemHomes = lib.concatMapAttrs (
    host: system:
    lib.mapAttrs' (user: home: lib.nameValuePair "${user}@${host}" home) system.config.home-manager.users
  ) self.darwinConfigurations;
  darwinGhostty =
    lib.mapAttrsToList (name: home: renderGhostty name home.config.programs.ghostty.settings) self.homeConfigurations
    ++ lib.mapAttrsToList (name: home: renderGhostty name home.programs.ghostty.settings) darwinSystemHomes;

  # Mac configurations must fully evaluate on Linux
  drvLine = name: drv: "${name}: ${builtins.unsafeDiscardStringContext drv.drvPath}";
  darwinDrvs =
    lib.mapAttrsToList (name: home: drvLine name home.activationPackage) self.homeConfigurations
    ++ lib.mapAttrsToList (name: system: drvLine name system.system) self.darwinConfigurations;

  linuxGhostty = self.nixosConfigurations.magpie.config.home-manager.users.arved.xdg.configFile."ghostty/config".source;

  linuxHome = self.nixosConfigurations.magpie.config.home-manager.users.arved;
  linuxKit = linuxHome.modules.kit.package;
  niriConfig = pkgs.writeText "niri.kdl" linuxHome.home.file.".config/niri/config.kdl".text;

  # The Mac variant of kit, built with Linux pkgs so its logic can run here
  darwinHome = lib.head (
    lib.attrValues (lib.filterAttrs (name: _: lib.hasSuffix "@work-mac" name) self.homeConfigurations)
  );
  darwinKitFor =
    systemType: host: user:
    import ../home/programs/kit/package.nix {
      inherit pkgs lib systemType host user;
      platform = "darwin";
      flake = "/repo";
      theme = "nord";
      themes = lib.attrNames themes;
      keys = import ../home/programs/kit/keys.nix {
        inherit lib;
        config = darwinHome.config;
        isDarwin = true;
      };
    };
  heronUser = self.darwinConfigurations.heron.config.system.primaryUser;
  darwinKit = darwinKitFor "none" "work-mac" darwinHome.config.home.username;
  darwinSystemKit = darwinKitFor "darwin" "heron" heronUser;

  themes = import ../home/themes { inherit pkgs; };
  light = linuxHome.specialisation."nord-light".configuration;

  # Base configuration plus every specialisation, by name ("nord-dark" is the base)
  looks = {
    "nord-dark" = linuxHome;
  }
  // lib.mapAttrs (_: s: s.configuration) linuxHome.specialisation;
  gvariantString = v: if builtins.isAttrs v && v ? value then v.value else v;

  failures = lib.runTests {
    testLightGtkTheme = {
      expr = light.gtk.theme.name;
      expected = "Nordic-Polar-Light";
    };
    testLightGtk4FollowsGtk = {
      expr = light.gtk.gtk4.theme.name;
      expected = "Nordic-Polar-Light";
    };
    testLightColorScheme = {
      expr = gvariantString light.dconf.settings."org/gnome/desktop/interface".color-scheme;
      expected = "prefer-light";
    };
    testLightNoctalia = {
      expr = light.programs.noctalia.settings.theme.mode;
      expected = "light";
    };
    # home-manager validates custom Ghostty themes with an unquoted path, so a
    # space in the name breaks the whole activation
    testGhosttyThemeNamesWithoutSpaces = {
      expr = lib.filter (lib.hasInfix " ") (lib.attrNames linuxHome.programs.ghostty.themes);
      expected = [ ];
    };
    testNoStartupOnlyCss = {
      expr = lib.all (cfg: cfg.gtk.gtk3.extraCss == "") (lib.attrValues looks);
      expected = true;
    };
    testDarkIsDefault = {
      expr = linuxHome.gtk.theme.name;
      expected = "Nordic";
    };
    testCmd = {
      expr = keybindings.toLinux "cmd+t";
      expected = "ctrl+shift+t";
    };
    testCmdShift = {
      expr = keybindings.toLinux "cmd+shift+d";
      expected = "ctrl+shift+alt+d";
    };
    testCmdAlt = {
      expr = keybindings.toLinux "cmd+alt+arrow_up";
      expected = "ctrl+shift+alt+arrow_up";
    };
    testCollisions = {
      expr = keybindings.collisions [
        { key = "a"; action = "x"; }
        { key = "a"; action = "y"; }
        { key = "b"; action = "z"; }
      ];
      expected = [ "a" ];
    };
    # Escape must reach apps unless a search is open (Ghostty's default)
    testDarwinGhosttyReload = {
      expr = lib.all (h: lib.hasInfix "pkill -USR2" h.xdg.configFile."ghostty/config".onChange) (
        lib.attrValues darwinSystemHomes ++ map (h: h.config) (lib.attrValues self.homeConfigurations)
      );
      expected = true;
    };
    testWallpaperFollowsLook = {
      expr = lib.mapAttrs (_: cfg: cfg.programs.noctalia.settings.wallpaper.default.path) looks;
      expected = lib.listToAttrs (
        lib.concatMap (
          name:
          map (mode: lib.nameValuePair "${name}-${mode}" "${themes.${name}.wallpaper.${mode}}") [
            "dark"
            "light"
          ]
        ) (lib.attrNames themes)
      );
    };
    testGnomeWallpaperPair = {
      expr = gvariantString linuxHome.dconf.settings."org/gnome/desktop/background".picture-uri-dark;
      expected = "file://${themes.nord.wallpaper.dark}";
    };
    testDarwinWallpapers = {
      expr = lib.mapAttrs (_: f: f.source) (
        lib.filterAttrs (name: _: lib.hasPrefix "wallpapers/" name)
          (lib.head (lib.attrValues darwinSystemHomes)).specialisation.ayu.configuration.xdg.dataFile
      );
      expected = {
        "wallpapers/light" = themes.ayu.wallpaper.light;
        "wallpapers/dark" = themes.ayu.wallpaper.dark;
      };
    };
    testEscapePerformable = {
      expr = lib.elem "performable:escape=end_search" linuxHome.programs.ghostty.settings.keybind;
      expected = true;
    };
    testPerformablePrefix = {
      expr = keybindings.ghostty {
        isDarwin = false;
        shared."cmd+c" = "copy_to_clipboard";
        platform."ctrl+tab" = "next_tab";
        performable = [ "copy_to_clipboard" ];
      };
      expected = [
        "clear"
        "performable:ctrl+shift+c=copy_to_clipboard"
        "ctrl+tab=next_tab"
      ];
    };
    # cmd+shift+d and ctrl+shift+alt+d end up on the same key on Linux
    testCollisionAborts = {
      expr =
        (builtins.tryEval (
          builtins.deepSeq (keybindings.ghostty {
            isDarwin = false;
            shared."cmd+shift+d" = "new_split:down";
            platform."ctrl+shift+alt+d" = "new_tab";
          }) null
        )).success;
      expected = false;
    };
  };
in
{
  keybindings-unit =
    assert lib.assertMsg (failures == [ ]) "Failed tests: ${builtins.toJSON failures}";
    pkgs.runCommand "keybindings-unit" { } "touch $out";

  darwin-eval = pkgs.writeText "darwin-eval" (lib.concatLines darwinDrvs);

  kit-linux = pkgs.runCommand "kit-linux" { } ''
    export HOME=$TMPDIR XDG_STATE_HOME=$TMPDIR/state KIT_DRY_RUN=1 KIT_FLAKE=/repo
    kit=${linuxKit}/bin/kit
    expect() { grep -qF -- "$2" <<<"$1" || { echo "expected '$2' in:"; echo "$1"; exit 1; }; }

    $kit help >/dev/null
    expect "$($kit build home 2>&1)" "nix build --no-link --print-out-paths /repo#nixosConfigurations.magpie.config.home-manager.users.arved.home.activationPackage"
    expect "$($kit build system 2>&1)" "/repo#nixosConfigurations.magpie.config.system.build.toplevel"
    expect "$($kit switch system 2>&1)" "sudo nixos-rebuild switch --flake /repo#magpie"
    expect "$($kit switch home 2>&1)" "<out>/activate"
    if $kit build nonsense 2>/dev/null; then echo "unknown target must fail"; exit 1; fi

    # theme/mode against a fake home-manager generation; a dry run does not
    # write state, so each step seeds it
    gen=$TMPDIR/gen; st=$XDG_STATE_HOME/kit
    mkdir -p $XDG_STATE_HOME/home-manager/gcroots $st
    for v in ${toString (lib.attrNames linuxHome.specialisation)}; do mkdir -p $gen/specialisation/$v; done
    ln -s $gen $XDG_STATE_HOME/home-manager/gcroots/current-home
    expect "$($kit light 2>&1)" "$gen/specialisation/nord-light/activate"
    echo light > $st/mode
    expect "$($kit theme ayu 2>&1)" "$gen/specialisation/ayu-light/activate"
    echo ayu > $st/theme
    expect "$($kit dark 2>&1)" "$gen/specialisation/ayu-dark/activate"
    expect "$($kit theme 2>&1)" "* ayu"
    echo dark > $st/mode
    expect "$($kit theme catppuccin 2>&1)" "$gen/specialisation/catppuccin-dark/activate"
    if $kit theme solarized 2>/dev/null; then echo "unknown theme must fail"; exit 1; fi
    # the variant generation is current now; going back must find the base again
    rm $XDG_STATE_HOME/home-manager/gcroots/current-home
    mkdir -p $TMPDIR/variantgen; ln -s $TMPDIR/variantgen $XDG_STATE_HOME/home-manager/gcroots/current-home
    expect "$($kit theme nord 2>&1)" "$gen/activate"

    # kit keys lists every binding exactly once
    ghostty=$($kit keys ghostty | wc -l)
    [ "$ghostty" -eq ${toString (lib.length linuxHome.programs.ghostty.settings.keybind - 1)} ] || { echo "ghostty: $ghostty"; exit 1; }
    niriExpected=$(awk '/^ *binds \{/{on=1; next} on && /^ *} *$/{on=0} on && /\{.*\}/ && !/^ *\/\//' ${niriConfig} | wc -l)
    niri=$($kit keys niri | wc -l)
    [ "$niri" -eq "$niriExpected" ] || { echo "niri: $niri, expected $niriExpected"; exit 1; }
    $kit keys gnome | grep -q "<Super>q"
    [ "$($kit keys firefox | wc -l)" -eq ${toString (lib.length (lib.filter (b: b.firefox != null) browserKeys))} ] || { echo "firefox keys incomplete"; exit 1; }
    $kit keys firefox | grep -q "^Ctrl+Shift+O  *Bookmark manager$"

    complete() { HOME=$TMPDIR ${pkgs.fish}/bin/fish --no-config -c "source ${linuxKit}/share/fish/vendor_completions.d/kit.fish; complete --do-complete '$1'" | cut -f1 | sort | tr '\n' ' '; }
    same() { [ "$1" = "$2" ] || { echo "expected '$2', got '$1'"; exit 1; }; }
    same "$(complete 'kit ')" "build dark help keys light switch theme "
    same "$(complete 'kit build ')" "home system "
    same "$(complete 'kit theme ')" "${toString (lib.attrNames themes)} "
    same "$(complete 'kit keys ')" "firefox ghostty gnome niri "
    [ -z "$(complete 'kit theme nord ')" ] || { echo "no completion after a theme"; exit 1; }
    touch $out
  '';

  kit-darwin = pkgs.runCommand "kit-darwin" { } ''
    export HOME=$TMPDIR XDG_STATE_HOME=$TMPDIR/state KIT_DRY_RUN=1
    kit=${darwinKit}/bin/kit
    expect() { grep -qF -- "$2" <<<"$1" || { echo "expected '$2' in:"; echo "$1"; exit 1; }; }

    expect "$($kit build home 2>&1)" '/repo#homeConfigurations."${darwinHome.config.home.username}@work-mac".activationPackage'
    if $kit build system 2>/dev/null; then echo "build system must fail on the Mac"; exit 1; fi
    expect "$($kit light 2>&1)" "set dark mode to false"
    expect "$($kit light 2>&1)" "set picture to \"$HOME/.local/share/wallpapers/light\""
    expect "$($kit dark 2>&1)" "set dark mode to true"
    expect "$($kit dark 2>&1)" "set picture to \"$HOME/.local/share/wallpapers/dark\""
    gen=$TMPDIR/gen; mkdir -p $gen/specialisation/ayu $XDG_STATE_HOME/home-manager/gcroots
    ln -s $gen $XDG_STATE_HOME/home-manager/gcroots/current-home
    expect "$($kit theme ayu 2>&1)" "$gen/specialisation/ayu/activate"
    expect "$($kit theme ayu 2>&1)" "set picture to"
    [ "$($kit keys | grep -c '^== ')" -eq 2 ] || { echo "Mac must only list chrome and ghostty keys"; exit 1; }
    $kit keys chrome | grep -q "^Cmd+Alt+B  *Bookmark manager$"
    if $kit keys chrome | grep -q "Bookmarks sidebar"; then echo "chrome has no bookmarks sidebar shortcut"; exit 1; fi
    complete() { HOME=$TMPDIR ${pkgs.fish}/bin/fish --no-config -c "source ${darwinKit}/share/fish/vendor_completions.d/kit.fish; complete --do-complete '$1'" | cut -f1 | sort | tr '\n' ' '; }
    same() { [ "$1" = "$2" ] || { echo "expected '$2', got '$1'"; exit 1; }; }
    same "$(complete 'kit switch ')" "home "
    same "$(complete 'kit keys ')" "chrome ghostty "

    kit=${darwinSystemKit}/bin/kit
    expect "$($kit build system 2>&1)" "/repo#darwinConfigurations.heron.system"
    expect "$($kit switch system 2>&1)" "sudo darwin-rebuild switch --flake /repo#heron"
    expect "$($kit build home 2>&1)" "/repo#darwinConfigurations.heron.config.home-manager.users.${heronUser}.home.activationPackage"
    complete() { HOME=$TMPDIR ${pkgs.fish}/bin/fish --no-config -c "source ${darwinSystemKit}/share/fish/vendor_completions.d/kit.fish; complete --do-complete '$1'" | cut -f1 | sort | tr '\n' ' '; }
    same "$(complete 'kit switch ')" "home system "
    touch $out
  '';

  # Every theme/mode: the referenced theme files exist, Ghostty accepts its theme pair,
  # and noctalia and color-scheme match
  themes-check = pkgs.runCommand "themes-check" { nativeBuildInputs = [ pkgs.ghostty pkgs.jq ]; } (
    ''
      export HOME=$TMPDIR XDG_CONFIG_HOME=$TMPDIR
      # custom Ghostty themes, where Ghostty looks for them
      mkdir -p $TMPDIR/ghostty/themes
      ${lib.concatMapStrings (
        n: "cp ${linuxHome.xdg.configFile."ghostty/themes/${n}".source} \"$TMPDIR/ghostty/themes/${n}\"\n"
      ) (lib.attrNames linuxHome.programs.ghostty.themes)}
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (
        name: cfg:
        let
          parts = lib.splitString "-" name;
          theme = themes.${lib.head parts};
          mode = lib.last parts;
          variant = theme.${mode};
          kv = cfg.xdg.configFile."Kvantum/${variant.kvantum.name}".source;
        in
        assert lib.assertMsg (cfg.gtk.theme.name == variant.gtk.name) "${name}: gtk theme";
        assert lib.assertMsg (
          lib.all (k: cfg.programs.noctalia.settings.theme.${k} == theme.noctalia.${k}) (lib.attrNames theme.noctalia)
        ) "${name}: noctalia";
        assert lib.assertMsg (cfg.programs.helix.settings.theme == variant.helix) "${name}: helix";
        assert lib.assertMsg (cfg.programs.noctalia.settings.theme.mode == mode) "${name}: noctalia mode";
        assert lib.assertMsg (
          gvariantString cfg.dconf.settings."org/gnome/desktop/interface".color-scheme == "prefer-${mode}"
        ) "${name}: color-scheme";
        assert lib.assertMsg (cfg.programs.btop.settings.color_theme == variant.btop) "${name}: btop";
        assert lib.assertMsg (lib.hasInfix "@define-color bg ${variant.walker.bg};"
          cfg.xdg.configFile."walker/themes/current/style.css".text
        ) "${name}: walker";
        assert lib.assertMsg (cfg.home.activation ? dropNoctaliaOverrides) "${name}: noctalia overrides";
        ''
          echo "== ${name}"
          test -d ${variant.gtk.package}/share/themes/${variant.gtk.name}/gtk-3.0
          ${lib.optionalString variant.gtk4 "test -d ${variant.gtk.package}/share/themes/${variant.gtk.name}/gtk-4.0"}
          test -d ${kv}
          ${lib.optionalString (variant.gtk.name == "Nordic-Polar-Light")
            "grep -q 'background: #d8dee9' ${variant.gtk.package}/share/themes/Nordic-Polar-Light/gtk-3.0/gtk.css"}
          # helix finds its themes in the default runtime compiled into the binary
          runtime=$(grep -ao '/nix/store/[a-z0-9]*-helix-default-runtime' ${linuxHome.programs.helix.package}/bin/.hx-wrapped | head -1)
          test -f "$runtime/themes/${variant.helix}.toml"
          ${lib.optionalString (theme ? noctaliaPalette) ''
            # every noctalia role and all 16 terminal colours, in both modes
            jq -e '[.dark, .light][] | (keys | map(select(startswith("m"))) | length == 16)
              and (.terminal.normal | length == 8) and (.terminal.bright | length == 8)' \
              ${pkgs.writeText "palette.json" cfg.xdg.configFile."noctalia/palettes/${theme.noctalia.custom_palette}.json".text}
          ''}
          ${
            if variant.btop == "TTY" then
              ""
            else if lib.hasPrefix "/" variant.btop then
              "test -f ${variant.btop}"
            else
              "test -f ${pkgs.btop}/share/btop/themes/${variant.btop}.theme"
          }
          ghostty +validate-config --config-file=${cfg.xdg.configFile."ghostty/config".source}
        ''
      ) looks
    )
    + "touch $out"
  );

  # The reload hook must reach a process running the real binary of the Ghostty package
  ghostty-reload =
    pkgs.runCommand "ghostty-reload"
      {
        hook = linuxHome.xdg.configFile."ghostty/config".onChange;
        passAsFile = [ "hook" ];
      }
      ''
        export USER=$(${pkgs.coreutils}/bin/id -un)
        for exe in ${linuxHome.programs.ghostty.package}/bin/.* ${linuxHome.programs.ghostty.package}/bin/*; do
          [ -f "$exe" ] || continue
          name=$(basename "$exe")
          # bash as stand-in: unlike coreutils it does not care about its own name
          cp ${pkgs.bash}/bin/bash "$TMPDIR/$name"
          "$TMPDIR/$name" -c 'while :; do sleep 1; done' &
          pid=$!
          sleep 0.5
          kill -0 $pid || { echo "stand-in for $name did not start"; exit 1; }
          [ "$(cat /proc/$pid/comm)" = "$(printf %.15s "$name")" ] || { echo "unexpected comm $(cat /proc/$pid/comm)"; exit 1; }
          grep pkill "$hookPath" | sh
          sleep 0.5
          if kill -0 $pid 2>/dev/null; then echo "reload hook missed a process running $name"; exit 1; fi
          echo "ok: $name"
        done
        touch $out
      '';

  ghostty-config = pkgs.runCommand "ghostty-config" { nativeBuildInputs = [ pkgs.ghostty ]; } ''
    export HOME=$TMPDIR XDG_CONFIG_HOME=$TMPDIR
    ghostty +validate-config --config-file=${linuxGhostty}
    ${lib.concatMapStrings (f: "ghostty +validate-config --config-file=${f}\n") darwinGhostty}
    touch $out
  '';
}
