# Ignore power management events in logind, and let acpid handle them instead.

{ ... }:

{
  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  services.acpid = {
    enable = true;
    lidEventCommands = ''
      export PATH=$PATH:/run/current-system/sw/bin

      lid_state=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $NF}')
      if [ $lid_state = "closed" ]; then
        systemctl suspend
      fi
    '';

    powerEventCommands = ''
      systemctl suspend
    '';
  };
}
