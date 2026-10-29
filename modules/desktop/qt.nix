{ pkgs, username, ... }:
{
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # qt6ct also registers as "qt5ct"
    style = "kvantum";
  };

  home-manager.users.${username} =
    { ... }:
    let
      qtctConf = ''
        [Appearance]
        style=kvantum
        icon_theme=Papirus-Dark
        standard_dialogs=default

        [Interface]
        dialog_buttons_have_icons=1
        menus_have_icons=true
        toolbutton_style=4
      '';
    in
    {
      xdg.configFile."qt5ct/qt5ct.conf".text = qtctConf;
      xdg.configFile."qt6ct/qt6ct.conf".text = qtctConf;
      xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Nordic
      '';
      xdg.configFile."Kvantum/Nordic".source = "${pkgs.nordic}/share/Kvantum/Nordic";
    };
}
