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
    unflake = flake: import flake {
      inherit system;
      config.allowUnfree = true;
    };
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

        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.roni = import ./home.nix;

            extraSpecialArgs = specialArgs;
          };
        }

        # Set up nix registry with nixpkgs flakes.
        ({ ... }: {
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            nixpkgs-unstable.flake = nixpkgs-unstable;
            elgato.flake = elgato;
          };
        })
      ];
    };
  };
}
