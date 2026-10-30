{
  inputs,
  self,
  username,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.overwriteBackup = true;
  home-manager.extraSpecialArgs = { inherit inputs self username; };

  home-manager.users.${username} = {
    imports = [
      ../home
      ../home/linux
    ];
    home.stateVersion = "25.05";
  };
}
