# This module defines the basic properties of all users.
{
  pkgs,
  username,
  userDescription,
  hashedPassword,
  ...
}:
{
  users.defaultUserShell = pkgs.fish;

  users.mutableUsers = false; # Allows only hashed Passwords
  
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
