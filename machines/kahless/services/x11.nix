{ nixpkgs, config, ... }:

{
  hardware.opengl.enable = true;

  services.xserver = {
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

    displayManager = with nixpkgs; {
      sessionCommands = ''
        #xbindkeys

        # Hide the mouse pointer after five second idle.
        ${unclutter}/bin/unclutter&

        # Set DPI.
        ${xorg.xrandr}/bin/xrandr --dpi 192

        # Set a black root window.
        ${xorg.xsetroot}/bin/xsetroot -solid black

        # Trigger xlock on suspend.
        ${xss-lock}/bin/xss-lock -- ${xlockmore}/bin/xlock -mode blank&

        # Run keyboard customizations.
        ${xorg.xmodmap}/bin/xmodmap ${config.xmodmap-config}

        # Start trayer.
        ${trayer}/bin/trayer --edge top --align left --SetDockType true --SetPartialStrut true --expand true --width 3 --transparent true --alpha 0 --tint 0x000000 --height 32&

        # Launch network manager applet (shows up in trayer).
        ${networkmanagerapplet}/bin/nm-applet&
      '';

      defaultSession = "none+xmonad";
    };
  };
}
