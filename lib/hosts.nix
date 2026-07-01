{ self, inputs, ... }:

let
  mkHost = hostDir: {
    arch ? "x86_64-linux",
    hostname ? hostDir,
    username ? "user",
    userDescription ? "Default User",
    hashedPassword ? null,
  }:
  let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = arch;
      config.allowUnfree = true;
    };
  in
  inputs.nixpkgs.lib.nixosSystem {
    system = arch;
    specialArgs = {
      inherit
        inputs
        self
        hostname
        username
        userDescription
        hashedPassword
        pkgs-unstable
        ;
      inherit (inputs) nixos-hardware;
    };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.niri.nixosModules.niri
      inputs.nur.modules.nixos.default
      inputs.sops-nix.nixosModules.sops 
      "${self}/default.nix"
      "${self}/hosts/${hostDir}"
      "${self}/lib/secrets.nix" 
    ];
  };
in

{
  mkHost = mkHost;
  genHosts = builtins.mapAttrs mkHost;
}
