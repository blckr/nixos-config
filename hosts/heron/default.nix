{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = 6;
}
