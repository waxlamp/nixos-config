{ nixpkgs, ... }:

{
  environment.systemPackages = with nixpkgs; [
    pmutils
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

  programs = {
    nm-applet.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };
}
