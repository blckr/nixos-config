# NixOS only: `osConfig` is always available here.
{
  imports = [
    ./appearance.nix
    ./cursor.nix
    ./ghostty.nix
    ./gnome.nix
    ./gtk.nix
    ./helix.nix
    ./niri.nix
    ./noctalia.nix
    ./ssh.nix
    ./udiskie.nix
    ./walker.nix
    ./xdg.nix
  ];
}
