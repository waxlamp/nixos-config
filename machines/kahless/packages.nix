{ nixpkgs, ... }:

{
  environment.systemPackages = with nixpkgs; [
    # System packages.
    kbfs
    xorg.xmodmap

    # User packages.
    bat
    brave
    elgato
    evince
    docker-compose
    fd
    feh
    file
    flameshot
    frobtads
    fzf
    gitFull
    htop
    killall
    lsof
    mpv
    ncdu
    neovim
    ntp
    pavucontrol
    python3
    slack
    spotify
    unzip
    up
    vscode
    xclip
    yadm
    yarn
    zoom-us
  ];

  programs = {
    tmux.enable = true;
    zsh.enable = true;
  };
}
