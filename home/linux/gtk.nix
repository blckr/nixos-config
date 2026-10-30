# Theme, icons and color-scheme are set in ./appearance.nix
{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
  };

  dconf.settings."org/gnome/desktop/interface".accent-color = "blue";
}
