{ nixpkgs, ... }:

{
  system.stateVersion = "22.05";

  boot = {
    kernelPackages = nixpkgs.linuxPackages_latest;

    # Use the gummiboot efi boot loader.
    loader = {
      systemd-boot.enable = true;
      timeout = 5;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/home" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}
