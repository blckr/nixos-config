{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [ ];

  home-manager.users.${username}.modules.kit.flake = "/Users/${username}/personal/nixos-config";

  system.stateVersion = 6;
}
