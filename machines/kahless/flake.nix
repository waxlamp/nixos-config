{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosConfigurations.kahless = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        # Set up nix registry with nixpkgs flakes.
        ({ lib, ... }: {
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.nixpkgs-unstable.flake = nixpkgs-unstable;
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
