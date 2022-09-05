{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-22.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.elgato.url = "github:waxlamp/elgato/flakes";

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, elgato }: {
    nixosConfigurations.kahless = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.roni = import ./home.nix;

            extraSpecialArgs = {
              inherit nixpkgs nixpkgs-unstable elgato;
            };
          };
        }

        # Set up nix registry with nixpkgs flakes.
        ({ lib, ... }: {
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
