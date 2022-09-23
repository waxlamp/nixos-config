{ config, pkgs, specialArgs, ... }:

let
  nixpkgs = specialArgs.nixpkgs;
  nixpkgs-unstable = specialArgs.nixpkgs-unstable;
  elgato = specialArgs.elgato;
in {
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "roni";
  home.homeDirectory = "/home/roni";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  home.packages = with nixpkgs; [
    elgato

    acpi
    bat
    fzf
    htop
    lsof
    brave
    colordiff
    diff-so-fancy
    evince
    fd
    feh
    file
    flameshot
    gitFull
    killall
    mpv
    ncdu
    neovim
    ntp
    pavucontrol
    python3
    shotgun
    slack
    slop
    spotify
    trayer
    unclutter
    unzip
    up
    vscode
    xclip
    xlockmore
    xorg.xbacklight
    xss-lock
    yadm
    yarn
    zoom-us
  ];
}
