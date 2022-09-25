# This module creates a new user-level systemd service to run an xmodmap script
# to remap keys appropriately, along with a new udev rule to detect the addition
# of the keyboard in question (plugged in via USB).

{ nixpkgs, config, ... }:

{
  systemd.user.services."udev-keyboard-xmodmap" =
    let
      keyboard-layout-script = nixpkgs.writeScript "udev-keyboard-xmodmap.sh" ''
        #!/bin/sh

        # Pausing before running xmodmap gives the system a chance to catch up.
        sleep 1
        ${nixpkgs.xorg.xmodmap}/bin/xmodmap ${config.xmodmap-config}
      '';
    in {
      enable = true;
      description = "Apply xmodmap configuration to physical keyboards when plugged in";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${nixpkgs.bash}/bin/bash ${keyboard-layout-script}";
      };
    };

  services.udev = {
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="input", ATTR{name}=="SONiX USB Keyboard", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="udev-keyboard-xmodmap.service"
    '';
  };
}
