{ nixpkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = [
      nixpkgs.brlaser
      (nixpkgs.callPackage ./hll2395dw-cups.nix {})
    ];
  };
}
