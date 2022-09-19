{ nixpkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = [
      nixpkgs.brlaser
      (nixpkgs.callPackage ../../../printers/hll2395dw-cups.nix {})
    ];
  };
}
