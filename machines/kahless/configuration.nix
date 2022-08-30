# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  fileSystems."/home" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  fileSystems."/mnt/kitwarenas2" = {
    device = "//kitwarenas2/Share";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.0";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/New_York";

  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set up console properties.
  console = {
    font = "LatArCyrHeb-sun32";
    keyMap = "us";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Nix 2.4 from unstable release.
  nix.package =
    let pkgsUnstable = import (pkgs.fetchFromGitHub {
      owner = "nixos";
      repo = "nixpkgs";
      rev = "6182b708a8841c6bf61fb12bd97949b746f8663e";
      sha256 = "E7isaioyGPQ5TGlpgi04dXPIDeRX3F4BJYq5nb2vcQc=";
    }) { system = config.nixpkgs.system; };
    in pkgsUnstable.nix_2_4;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pmutils
    networkmanagerapplet
    docker_compose
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
    pkgs.zsh
  ];

  environment.etc."nsswitch.conf".text = "
passwd:    files mymachines systemd
group:     files mymachines systemd
shadow:    files

hosts:     files mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns mdns myhostname
networks:  files

ethers:    files
services:  files
protocols: files
rpc:       files
  ";

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
      xmodmap-script = pkgs.writeText "xmodmap" ''
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
        ExecStart = "${pkgs.bash}/bin/bash ${pkgs.writeScript "keyboard-layout.sh" ''
          #!/bin/sh

          sleep 1
          ${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmap-script}
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
      pkgs.brlaser
      (pkgs.callPackage ../../printers/hll2395dw-cups.nix {})
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
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;
  hardware.opengl.enable = true;

  nixpkgs.config.allowUnfree = true;

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
      shell = pkgs.zsh;
      packages = with pkgs; [];
    };
  };
}
