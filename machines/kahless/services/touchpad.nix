{ ... }:

{
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      clickMethod = "clickfinger";
      additionalOptions = ''
        Option "TappingButtonMap" "lmr"
      '';
    };
  };
}
