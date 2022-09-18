{ nixpkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with nixpkgs; [
    pmutils
    networkmanagerapplet
    docker-compose
    alacritty
    tmuxinator
    kbfs

    xorg.xmodmap

    # Haskell packages for XMonad
    xmonad-with-packages
    xmobar

    # Launcher for use with XMonad
    rofi
  ];
}
