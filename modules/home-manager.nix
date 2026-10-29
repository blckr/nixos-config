{
  username, ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.overwriteBackup = true;
  home-manager.users.${username}.home.stateVersion = "25.05";
}
