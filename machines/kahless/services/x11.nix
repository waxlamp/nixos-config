{ ... }:

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

    displayManager = {
      sessionCommands = ''
        sh ~/.xinitrc
      '';

      defaultSession = "none+xmonad";
    };
  };
}
