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
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
  documentation.man.cache.enable = lib.mkForce false;
}
