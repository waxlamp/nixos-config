{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosConfigurations.kahless = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        ({ lib, ... }: {
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.nixpkgs-unstable.flake = nixpkgs-unstable;
        })
      ];
    };
  };
}
