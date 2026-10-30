{ pkgs, username, ... }:
{
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # qt6ct also registers as "qt5ct"
    style = "kvantum";
  };
}
