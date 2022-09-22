{ ... }:

{
  networking = {
    hostName = "kahless";

    # Let NetworkManager handle network connections.
    networkmanager.enable = true;
    useDHCP = false;
  };
}
