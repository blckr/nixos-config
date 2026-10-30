# Standalone home-manager for machines without NixOS (Mac).
# Linux machines get home-manager through NixOS, see system/home-manager.nix.
{ self, inputs, ... }:

let
  lib = inputs.nixpkgs.lib;

  mkHome =
    hostDir:
    {
      arch,
      username,
      hostname ? hostDir,
      ...
    }:
    let
      hostHome = "${self}/hosts/${hostDir}/home.nix";
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = arch;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit
          inputs
          self
          username
          hostname
          ;
        settings = import "${self}/settings.nix";
      };
      modules = [
        "${self}/home"
        "${self}/home/darwin"
        {
          home = {
            inherit username;
            homeDirectory = "/Users/${username}";
            stateVersion = "26.05";
          };
        }
      ]
      ++ lib.optional (builtins.pathExists hostHome) hostHome;
    };
in
{
  inherit mkHome;

  # { work-mac = { arch = "aarch64-darwin"; username = "…"; }; } -> { "…@work-mac" = …; }
  genHomes =
    hosts:
    lib.mapAttrs' (
      hostDir: host: lib.nameValuePair "${host.username}@${host.hostname or hostDir}" (mkHome hostDir host)
    ) hosts;
}
