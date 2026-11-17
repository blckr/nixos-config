{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib; let
  cfg = config.modules.services.storage;
in {
  options.modules.services.storage = {
    enable = mkEnableOption "Enable USB automounting and storage services";
  };

  config = mkIf cfg.enable {
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
    };

    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
               action.id == "org.freedesktop.udisks2.filesystem-mount" ||
               action.id == "org.freedesktop.udisks2.encrypted-unlock-system" ||
               action.id == "org.freedesktop.udisks2.encrypted-unlock") &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    environment.systemPackages = with pkgs; [
      ntfs3g
      exfat
      dosfstools
    ];
  };
}
