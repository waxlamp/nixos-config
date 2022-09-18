# This module creates a new user-level systemd service to run an xmodmap script
# to remap keys appropriately, along with a new udev rule to detect the addition
# of the keyboard in question (plugged in via USB).

{ nixpkgs, ... }:

{
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

  services.udev = {
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="input", ATTR{name}=="SONiX USB Keyboard", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="keyboard-layout.service"
    '';
  };
}
