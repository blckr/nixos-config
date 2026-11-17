{
  inputs,
  self,
  username,
  hostname,
  settings,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostname;
  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

  programs.fish.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = {
    inherit
      inputs
      self
      username
      hostname
      settings
      ;
  };
  home-manager.users.${username} = {
    imports = [
      ../../home
      ../../home/darwin
    ];
    home.stateVersion = "26.05";
  };
}
