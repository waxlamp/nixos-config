{ nixpkgs, ... }:

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

        # Run unclutter so the mouse pointer disappears after five seconds.
        ${unclutter}/bin/unclutter&

        # Set DPI.
        ${xorg.xrandr}/bin/xrandr --dpi 192

        # Black root window
        ${xorg.xsetroot}/bin/xsetroot -solid black

        # Trigger xlock on suspend.
        ${xss-lock}/bin/xss-lock -- ${xlockmore}/bin/xlock -mode blank&

        # Turn capslock into super
        xmodmap ~/.xmodmap

        # Start trayer
        ${trayer}/bin/trayer --edge top --align left --SetDockType true --SetPartialStrut true --expand true --width 3 --transparent true --alpha 0 --tint 0x000000 --height 32&
        ${networkmanagerapplet}/bin/nm-applet&
      '';

      defaultSession = "none+xmonad";
    };
  };
}
