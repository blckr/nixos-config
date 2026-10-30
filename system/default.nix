{
  imports = [
    ./development.nix # Can be deleted if not needed
  
    ./home-manager.nix
    ./nix.nix
    ./users.nix

    ./core
    ./desktop
    ./hardware
    ./programs
    ./services
    ./apps
  ];
}
