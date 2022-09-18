{ ... }:

{
  networking = {
    hostName = "kahless";
    useDHCP = false;
    networkmanager = {
        enable = true;
    };
    wireless.enable = false;
  };
}
