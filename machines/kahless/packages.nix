{ nixpkgs, ... }:

{
  environment.systemPackages = with nixpkgs; [
    # System packages.
    acpi
    alacritty
    kbfs
    pmutils
    rofi
    shotgun
    slop
    tmuxinator
    xclip
    xlockmore
    xorg.xbacklight
    xorg.xmodmap
    xmonad-with-packages
    xmobar

    # User packages.
    bat
    brave
    colordiff
    diff-so-fancy
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
    yadm
    yarn
    zoom-us
  ];

  programs = {
    tmux.enable = true;
    zsh.enable = true;
  };
}
