{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-22.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.elgato = {
    url = "github:waxlamp/elgato/flakes";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, elgato }:
  let
    system = "x86_64-linux";
    unflake = flake: import flake {
      inherit system;
      config.allowUnfree = true;
    };
    specialArgs = {
      nixpkgs = unflake nixpkgs;
      nixpkgs-unstable = unflake nixpkgs-unstable;
      elgato = elgato.defaultPackage.${system};
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
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.nixpkgs-unstable.flake = nixpkgs-unstable;
          nix.registry.elgato.flake = elgato;
        })

        # Configure nixpkgs.
        ({ ... }: {
          nixpkgs.config = {
            allowUnfree = true;
          };
        })
      ];
    };
  };
}
