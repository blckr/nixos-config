{
  username, ...
}:
{
  home-manager.useGlobalPkgs = true;
  # Alles ist in Nix verwaltet: kollidierende Dateien wegsichern, alte Backups überschreiben
  home-manager.backupFileExtension = "backup";
  home-manager.overwriteBackup = true;
  home-manager.users.${username}.home.stateVersion = "25.05";
}
