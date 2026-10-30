{ self, inputs, ... }:

let
  hosts = import ./hosts.nix {
    self = self;
    inputs = inputs;
  };
  systems = import ./systems.nix {
    nixpkgs = inputs.nixpkgs;
  };
  homes = import ./homes.nix {
    self = self;
    inputs = inputs;
  };
  secrets = import ./secrets.nix;

  isDarwin = host: inputs.nixpkgs.lib.hasSuffix "darwin" (host.arch or "x86_64-linux");
  only = pred: inputs.nixpkgs.lib.filterAttrs (_: pred);
in

{
  inherit (hosts) mkHost;
  inherit (homes) mkHome;

  # One list of all machines, split by platform
  genHosts = all: hosts.genHosts (only (h: !isDarwin h) all);
  genHomes = all: homes.genHomes (only isDarwin all);
  inherit (systems) eachSystem;
  inherit secrets;
}
