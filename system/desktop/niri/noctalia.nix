{
  config,
  lib,
  username,
  inputs,
  pkgs,
  ...
}:
lib.mkIf config.modules.desktop.enable {
  # Battery and power profile data for the bar
  services.upower.enable = true;
}
