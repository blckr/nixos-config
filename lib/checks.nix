# `nix flake check`: Keybinding-Übersetzung und Ghostty-Configs beider Plattformen
{
  self,
  pkgs,
  lib,
}:
let
  keybindings = import ./keybindings.nix { inherit lib; };
  binds = import ../home/programs/ghostty/keybinds.nix;

  # Mac-Config wird hier mit Linux-pkgs erzeugt, damit kein Darwin-Builder nötig ist
  darwinGhostty = pkgs.writeText "ghostty-darwin.conf" (
    lib.concatMapStrings (b: "keybind = ${b}\n") (
      keybindings.ghostty {
        isDarwin = true;
        inherit (binds) shared;
        platform = binds.common // binds.darwin;
      }
    )
    + "macos-option-as-alt = left\n"
  );
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

  ghostty-config = pkgs.runCommand "ghostty-config" { nativeBuildInputs = [ pkgs.ghostty ]; } ''
    export HOME=$TMPDIR XDG_CONFIG_HOME=$TMPDIR
    ghostty +validate-config --config-file=${linuxGhostty}
    ghostty +validate-config --config-file=${darwinGhostty}
    touch $out
  '';
}
