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
  ];

  # List services that you want to enable:
  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = ["intel"];

      windowManager = {
          xmonad = {
              enable = true;
              enableContribAndExtras = true;
          };
      };

      desktopManager.xterm.enable = false;

      displayManager = {
        sessionCommands = ''
          sh ~/.xinitrc
        '';

        defaultSession = "none+xmonad";
      };
    };
  };

  hardware.opengl.enable = true;

  programs = {
    gnupg.agent.enable = true;

    tmux.enable = true;

    zsh.enable = true;
  };
}
