{ ... }:

{
  fileSystems."/mnt/kitwarenas2" = {
    device = "//kitwarenas2/Share";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.0";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };
}
