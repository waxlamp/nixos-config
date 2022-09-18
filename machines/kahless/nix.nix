{ nixpkgs, ... }:

{
  # Install Nix 2.8 from stable.
  nix.package = nixpkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
