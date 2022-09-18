{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elgato = {
      url = "github:waxlamp/elgato/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
};

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, elgato }:
  let
    system = "x86_64-linux";

    # Module to set up the flakes registry with the same package sets as the
    # system configuration uses.
    flake-registry-module = { ... }: {
      nix.registry = {
        nixpkgs.flake = nixpkgs;
        nixpkgs-unstable.flake = nixpkgs-unstable;
        elgato.flake = elgato;
      };
    };

    # Config for home-manager module.
    home-manager-config = {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.roni = import ./home.nix;

        extraSpecialArgs = specialArgs;
      };
    };

    # Convert a flake into a package set (allow unfree packages by default).
    unflake = flake: import flake {
      inherit system;
      config.allowUnfree = true;
    };

    # Arrange to pass the instantiated package sets into every module (via the
    # `specialArgs` value).
    nixpkgs' = unflake nixpkgs;
    specialArgs = {
      nixpkgs = nixpkgs';
      nixpkgs-unstable = unflake nixpkgs-unstable;
      elgato = elgato.defaultPackage.${system};
      pkgs = nixpkgs';
    };
  in {
    nixosConfigurations.kahless = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit specialArgs;

      modules = [
        ./machines/kahless/configuration.nix
        home-manager.nixosModules.home-manager home-manager-config
        flake-registry-module
      ];
    };
  };
}
