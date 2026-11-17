{
  pkgs,
  username,
  userDescription,
  hashedPassword,
  ...
}:
{
  users.defaultUserShell = pkgs.fish;

  users.mutableUsers = false;
  
  users.users.${username} = {
    isNormalUser = true;
    description = userDescription;
    hashedPassword = hashedPassword;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "scanner"
      "tty"
      "dialout"
      "disk"
      "storage"
    ];
  };
}
