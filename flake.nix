{
  description = "NixOS Configuration System from Arved";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      sops-nix,
      ...
    }@inputs:
    let
      lib = import ./lib {
        inherit self inputs;
      };

      # arch = "…-darwin" becomes a homeConfiguration (home-manager only), with darwinSystem = true
      # a darwinConfiguration; everything else a nixosConfiguration
      hosts = {
        magpie = {
          username = "arved";
          userDescription = "Arved Bloecker";
          hostname = "magpie";
          # Generate the hashedPassword with mkpasswd
          hashedPassword = "$y$j9T$b2Obca/x4HHLzhGeiTBqr/$G.8GGokLUklJ0qnDKx.3l4pvnQWKNP/X.PROPM0BPIC";
        };
        bluejay = {
          username = "arved";
          userDescription = "Arved Bloecker";
          hostname = "bluejay";
          # Generate the hashedPassword with mkpasswd
          hashedPassword = "$y$j9T$b2Obca/x4HHLzhGeiTBqr/$G.8GGokLUklJ0qnDKx.3l4pvnQWKNP/X.PROPM0BPIC";
        };
        # TODO: set the username of the work Mac
        work-mac = { arch = "aarch64-darwin"; username = "arved"; };
        heron = { arch = "aarch64-darwin"; username = "bloecker"; darwinSystem = true; };
      };
    in
    {
      nixosConfigurations = lib.genHosts hosts;
      homeConfigurations = lib.genHomes hosts;
      darwinConfigurations = lib.genDarwins hosts;

      # Needs the live desktop session, so it is a runnable test, not a flake check
      packages.x86_64-linux.firefox-tabbar-test =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          home = self.nixosConfigurations.magpie.config.home-manager.users.arved;
        in
        pkgs.writeShellApplication {
          name = "firefox-tabbar-test";
          runtimeInputs = [
            pkgs.sway
            pkgs.grim
            pkgs.imagemagick
            home.programs.firefox.finalPackage
          ];
          text = builtins.readFile ./tests/firefox-tabbar.sh;
        };

      checks.x86_64-linux = import ./lib/checks.nix {
        inherit self;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        lib = nixpkgs.lib;
      };

      lib = lib;
    };
}
