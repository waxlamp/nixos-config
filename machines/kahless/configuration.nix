# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ nixpkgs, nixpkgs-unstable, elgato, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system.nix
      ./console.nix
      ./mounts.nix
      ./nix.nix
    ];

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with nixpkgs; [
    pmutils
    networkmanagerapplet
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

  environment.shells = [
    nixpkgs.zsh
  ];

  environment.etc."nsswitch.conf".text = ''
    passwd:    files mymachines systemd
    group:     files mymachines systemd
    shadow:    files

    hosts:     files mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns mdns myhostname
    networks:  files

    ethers:    files
    services:  files
    protocols: files
    rpc:       files
  '';

  networking = {
    hostName = "kahless";
    useDHCP = false;
    networkmanager = {
        enable = true;
    };
    wireless.enable = false;
  };

  systemd.user.services."keyboard-layout" =
    let
      xmodmap-script = nixpkgs.writeText "xmodmap" ''
        clear lock
        clear mod4
        keycode 66 = Super_L
        add mod4 = Super_L
      '';
    in {
      enable = true;
      description = "Remap keys on my physical keyboard";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${nixpkgs.bash}/bin/bash ${nixpkgs.writeScript "keyboard-layout.sh" ''
          #!/bin/sh

          sleep 1
          ${nixpkgs.xorg.xmodmap}/bin/xmodmap ${xmodmap-script}
        ''}";
      };
  };

  # List services that you want to enable:
  services = {
    # Locate service.
    locate.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Keybase service
    keybase.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [
      nixpkgs.brlaser
      (nixpkgs.callPackage ../../printers/hll2395dw-cups.nix {})
    ];

    # Enable bluetooth.
    blueman.enable = true;

    # Avahi
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };

    # Udev
    udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="input", ATTR{name}=="SONiX USB Keyboard", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="keyboard-layout.service"
      '';
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
