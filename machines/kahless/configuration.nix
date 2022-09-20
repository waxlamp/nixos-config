# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ nixpkgs, nixpkgs-unstable, elgato, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./console.nix
    ./mounts.nix
    ./nix.nix
    ./packages.nix
    ./networking.nix
    ./nsswitch.nix
    ./users.nix
    ./keyboard-layout.nix
    ./services/locate.nix
    ./services/openssh.nix
    ./services/keybase.nix
    ./services/printing
    ./services/bluetooth.nix
    ./services/avahi.nix
    ./services/virtualization.nix
    ./services/audio.nix
    ./services/power-management.nix
    ./services/touchpad.nix
    ./services/x11.nix
  ];

  programs = {
    gnupg.agent.enable = true;

    tmux.enable = true;

    zsh.enable = true;
  };
}
