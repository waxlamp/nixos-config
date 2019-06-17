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

  #fileSystems."/mnt/kitwarenas5" = {
    #device = "//kitwarenas5/Share";
    #fsType = "cifs";
    #options =
      #let
        ## this line prevents hanging on network split
        #automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      #in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  #};

  #boot.kernelPackages = pkgs.linuxPackages_3_18;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/New_York";

  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Select internationalisation properties.
  i18n = {
    #consoleFont = "lat9w-16";
    consoleFont = "LatArCyrHeb-sun32";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set nix path.
  #nix.nixPath = [
    #"nixpkgs=/home/roni/.nix-defexpr/channels/nixos/nixpkgs"
    #"nixos-config=/etc/nixos/configuration.nix"
  #];

  # Copy system config to the store.
  system.copySystemConfiguration = true;

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    zsh
    #mesa
    pmutils
    #(wine.override { wineBuild = "wineWow"; })
    networkmanagerapplet
    docker_compose

    # Haskell packages for XMonad
    xmonad-with-packages
  ];

  environment.shells = [
    "/run/current-system/sw/bin/zsh"
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
      pkgs.hll2390dw-cups
      #(pkgs.callPackage ../../printers/hll2395dw-cups.nix {})
    ];

    # Fix to enable trayer/nm-applet to start properly
    # (https://github.com/NixOS/nixpkgs/issues/16327#issuecomment-227218371).
    gnome3.at-spi2-core.enable = true;

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

          default = "xmonad";
      };

      desktopManager.xterm.enable = false;

      displayManager = {
        sessionCommands = ''
          sh ~/.xinitrc
        '';

        # Uncomment to restore default SLiM theme.
        #slim.theme = null;
      };

      synaptics = {
          enable = false;
          palmDetect = true;
          tapButtons = true;
          twoFingerScroll = true;
      };

      libinput = {
        enable = true;
        clickMethod = "clickfinger";
        additionalOptions = ''
          Option "TappingButtonMap" "lmr"
        '';
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

    # Kubernetes.
    #kubernetes = {
      #roles = ["master" "node"];
    #};
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
  hardware.pulseaudio.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # 32-bit DRI support.
  hardware.opengl.driSupport32Bit = true;

  nixpkgs.config.allowUnfree = true;

  #security.grsecurity.enable = false;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   name = "guest";
  #   group = "users";
  #   uid = 1000;
  #   createHome = true;
  #   home = "/home/guest";
  #   shell = "/run/current-system/sw/bin/bash";
  # };

  users.extraUsers = {
    roni = {
      name = "roni";
      group = "users";
      extraGroups = [
        "wheel"
        "vboxusers"
        "docker"
        "networkmanager"
      ];
      uid = 1000;
      home = "/home/roni";
      shell = "/run/current-system/sw/bin/zsh";
      packages = with pkgs; [
        hello
      ];
    };
  };
}
