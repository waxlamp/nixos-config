{ nixpkgs, ... }:

{
  services.keybase = {
    enable = true;
  };

  environment.systemPackages = with nixpkgs; [
    kbfs
  ];
}
