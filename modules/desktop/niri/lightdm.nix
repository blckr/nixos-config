{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.modules.desktop.enable {
  services.displayManager.sessionPackages = [ pkgs.niri ];

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = config.modules.theme.data.wallpaper;

    greeters.slick = {
      enable = true;
      theme.name = config.modules.theme.data.gtk.name;
      theme.package = config.modules.theme.data.gtk.package;

      iconTheme.name = config.modules.theme.data.gtk.icons;
      iconTheme.package = config.modules.theme.data.gtk.iconPackage;

      cursorTheme.name = "Adwaita";
      cursorTheme.package = pkgs.adwaita-icon-theme;
      cursorTheme.size = 24;

      font = {
        name = "JetBrains Mono 11";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      extraConfig = ''
        background = ${config.modules.theme.data.wallpaper}
        show-clock = true
        show-keyboard = true
        show-power = true
        draw-grid = false
        draw-user-backgrounds = false
      '';
    };
  };
}
