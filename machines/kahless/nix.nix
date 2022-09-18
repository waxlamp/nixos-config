{ nixpkgs-unstable, ... }:

{
  # Install Nix 2.11 from unstable.
  nix.package = nixpkgs-unstable.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
