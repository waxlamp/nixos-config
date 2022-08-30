{ config, pkgs, ... }:

let
  sources = import ./nix/sources.nix;
  pkgs-2021-03-30 = import sources.nixpkgs-2021-03-30 {};
  pkgs-2021-06-26 = import sources.nixpkgs-2021-06-26 {};
  pkgs-2021-07-13 = import sources.nixpkgs-2021-07-13 {};
in {
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    command-not-found.enable = false;
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

  home.packages = with pkgs; [
    acpi
    bat
    fzf
    htop
    jetbrains-mono
    jq
    kbfs
    keybase-gui
    lsof
    magic-wormhole
    bitwarden-cli
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
    niv
    nodejs
    pavucontrol
    pipenv
    python3
    python38Packages.poetry
    rhythmbox
    silver-searcher
    slack
    spotify
    sweethome3d.application
    tmux
    tmuxinator
    trayer
    unclutter
    unzip
    xclip
    xlockmore
    xorg.xbacklight
    xorg.xmodmap
    xss-lock
    yadm
    yarn
    zoom-us
  ] ++ (with pkgs-2021-03-30; [
    vscode
  ]);
}
