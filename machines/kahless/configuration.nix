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
    ./keyboard-layout.nix
    ./services/locate.nix
    ./services/openssh.nix
    ./services/keybase.nix
    ./services/bluetooth.nix
  ];

  environment.shells = [
    nixpkgs.zsh
  ];

  # List services that you want to enable:
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [
      nixpkgs.brlaser
      (nixpkgs.callPackage ../../printers/hll2395dw-cups.nix {})
    ];

    # Avahi
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };

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

      synaptics = {
          enable = false;
          palmDetect = true;
          tapButtons = true;
          twoFingerScroll = true;
      };

      libinput = {
        enable = true;
        touchpad = {
          clickMethod = "clickfinger";
          additionalOptions = ''
            Option "TappingButtonMap" "lmr"
          '';
        };
      };
    };

    # Power management.
    logind = {
      lidSwitch = "ignore";
     extraConfig = ''
          HandlePowerKey=ignore
      '';
    };
    acpid = {
      enable = true;
      lidEventCommands =
        ''
          export PATH=$PATH:/run/current-system/sw/bin

          lid_state=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $NF}')
          if [ $lid_state = "closed" ]; then
              systemctl suspend
          fi
        '';

      powerEventCommands =
        ''
          systemctl suspend
        '';
    };
  };

  virtualisation = {
    docker.enable = true;

    virtualbox = {
      guest = {
        enable = false;
      };

      host = {
        enable = false;
        enableHardening = true;
        addNetworkInterface = true;
      };
    };
  };

  # PulseAudio
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    # The full package includes bluetooth support.
    package = nixpkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;
  hardware.opengl.enable = true;

  programs = {
    gnupg.agent.enable = true;

    tmux.enable = true;

    zsh.enable = true;
  };

  users.extraUsers = {
    roni = {
      name = "roni";
      isNormalUser = true;
      group = "users";
      extraGroups = [
        "wheel"
        "vboxusers"
        "docker"
        "networkmanager"
      ];
      uid = 1000;
      home = "/home/roni";
      shell = nixpkgs.zsh;
      packages = with nixpkgs; [];
    };
  };
}
