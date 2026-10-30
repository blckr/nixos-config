# NixOS only: `osConfig` is always available here.
{ pkgs, ... }:
{
  imports = [
    ./appearance.nix
    ./cursor.nix
    ./gnome.nix
    ./gtk.nix
    ./helix.nix
    ./niri.nix
    ./noctalia.nix
    ./qt.nix
    ./ssh.nix
    ./udiskie.nix
    ./walker.nix
    ./xdg.nix
  ];

  programs.ghostty.package = pkgs.ghostty;
}
