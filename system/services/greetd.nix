{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "console=tty12"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "niri";
      user.default = username;
      appearance = {
        scheme = "Nord";
        wallpaper.fill_color = "#2e3440";
      };
      cursor = {
        theme = "Adwaita";
        size = 18;
        path = pkgs.adwaita-icon-theme;
      };
      keyboard = {
        layout = "us";
        variant = "altgr-intl";
        options = "caps:none";
      };
    };
  };
}
