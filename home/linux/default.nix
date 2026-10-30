# Nur unter NixOS: hier ist `osConfig` immer verfügbar.
{ pkgs, ... }:
{
  imports = [
    ./cursor.nix
    ./fnott.nix
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
