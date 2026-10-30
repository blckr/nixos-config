{ lib, pkgs, osConfig, ... }:
{
  config = lib.mkIf osConfig.modules.services.storage.enable {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";

      settings = {
        program_options = {
          file_manager = "${pkgs.ranger}/bin/ranger";
        };
      };
    };
  };
}
