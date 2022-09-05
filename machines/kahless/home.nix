{ config, pkgs, specialArgs, ... }:

let
  nixpkgs = specialArgs.nixpkgs.legacyPackages.x86_64-linux;
  nixpkgs-unstable = specialArgs.nixpkgs-unstable;
  elgato = specialArgs.elgato.defaultPackage.x86_64-linux;
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

  home.packages = with nixpkgs; [
    elgato

    acpi
    bat
    firefox
    fzf
    htop
    jetbrains-mono
    jq
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
    lazygit
    miller
    mpv
    ncdu
    neovim
    nodejs
    ntp
    pavucontrol
    pipenv
    poppler_utils
    python3
    python38Packages.poetry
    rhythmbox
    shotgun
    silver-searcher
    slop
    #spotify
    sweethome3d.application
    terraform_0_15
    tmuxinator
    trayer
    tree
    unclutter
    unzip
    up
    #vscode
    xclip
    xlockmore
    xorg.xbacklight
    xss-lock
    yadm
    yarn
    #zoom-us
  ] ++ (with nixpkgs-unstable; [
    #slack
  ]);
}
