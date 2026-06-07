{
  description = "NixOS Configuration System from Arved";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
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
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/v5";
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
    in
    {
      nixosConfigurations = lib.genHosts {
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
      };

      lib = lib;
    };
}
