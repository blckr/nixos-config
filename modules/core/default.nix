{ lib, ... }:
{
  imports = [
    ./boot.nix
    ./firmware.nix
    ./locale.nix
    ./networking.nix
    ./power-management.nix
    ./security.nix
    ./systemd.nix

    ./system-packages.nix
    ./theme.nix
  ];

  nixpkgs.config.allowUnfree = true;
  documentation.man.cache.enable = lib.mkForce false;
}
