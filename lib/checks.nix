# `nix flake check`: Keybinding-Übersetzung und Ghostty-Configs beider Plattformen
{
  self,
  pkgs,
  lib,
}:
let
  keybindings = import ./keybindings.nix { inherit lib; };
  binds = import ../home/programs/ghostty/keybinds.nix;

  # Ghostty-Settings eines Mac-Rechners als Config-Datei, mit Linux-pkgs geschrieben
  # (kein Darwin-Builder nötig)
  renderGhostty =
    name: settings:
    pkgs.writeText "ghostty-${name}.conf" (
      lib.concatStrings (
        lib.mapAttrsToList (
          key: values: lib.concatMapStrings (v: "${key} = ${lib.generators.mkValueStringDefault { } v}\n") values
        ) settings
      )
    );
  darwinGhostty = lib.mapAttrsToList (
    name: home: renderGhostty name home.config.programs.ghostty.settings
  ) self.homeConfigurations;

  # Mac-Konfigurationen müssen unter Linux vollständig auswerten
  darwinDrvs = lib.mapAttrsToList (
    name: home: "${name}: ${builtins.unsafeDiscardStringContext home.activationPackage.drvPath}"
  ) self.homeConfigurations;

  linuxGhostty = self.nixosConfigurations.magpie.config.home-manager.users.arved.xdg.configFile."ghostty/config".source;

  failures = lib.runTests {
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
    # cmd+shift+d und ctrl+shift+alt+d landen auf Linux auf derselben Taste
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
    assert lib.assertMsg (failures == [ ]) "Fehlgeschlagene Tests: ${builtins.toJSON failures}";
    pkgs.runCommand "keybindings-unit" { } "touch $out";

  darwin-eval = pkgs.writeText "darwin-eval" (lib.concatLines darwinDrvs);

  ghostty-config = pkgs.runCommand "ghostty-config" { nativeBuildInputs = [ pkgs.ghostty ]; } ''
    export HOME=$TMPDIR XDG_CONFIG_HOME=$TMPDIR
    ghostty +validate-config --config-file=${linuxGhostty}
    ${lib.concatMapStrings (f: "ghostty +validate-config --config-file=${f}\n") darwinGhostty}
    touch $out
  '';
}
