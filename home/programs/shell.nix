# Shell and CLI tools, the same on NixOS and the Mac
{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -gx MANROFFOPT "-c"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  home.packages = with pkgs; [
    bat
    fastfetch
    file
    htop
    lazygit
    p7zip
    tree
    unzip
  ];
}
