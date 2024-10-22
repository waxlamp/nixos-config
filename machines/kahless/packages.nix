{ nixpkgs, nixpkgs-unstable, ... }:

{
  environment.systemPackages = with nixpkgs; [
    bat
    elgato
    fd
    fzf
    gitFull
    killall
    neovim
    ntp
    pavucontrol
    unzip
    xclip
    yarn
  ] ++ (with nixpkgs-unstable; [
    brave
    slack
    obsidian
  ]);

  programs = {
    nix-ld.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };
}
