{ nixpkgs, ... }:

{
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  environment.systemPackages = [
    nixpkgs.pinentry-curses
  ];
}
