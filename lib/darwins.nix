# nix-darwin for Macs that get a system configuration, see system/darwin
{ self, inputs, ... }:

let
  mkDarwin =
    hostDir:
    {
      arch,
      username,
      hostname ? hostDir,
      ...
    }:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          self
          username
          hostname
          ;
        settings = import "${self}/settings.nix";
      };
      modules = [
        inputs.home-manager.darwinModules.home-manager
        "${self}/system/darwin"
        "${self}/hosts/${hostDir}"
        { nixpkgs.hostPlatform = arch; }
      ];
    };
in
{
  inherit mkDarwin;
  genDarwins = builtins.mapAttrs mkDarwin;
}
