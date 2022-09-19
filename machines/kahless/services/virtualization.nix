{ ... }:

{
  virtualisation = {
    docker = {
      enable = true;
    };

    virtualbox = {
      guest = {
        enable = false;
      };

      host = {
        enable = false;
        enableHardening = true;
        addNetworkInterface = true;
      };
    };
  };
}
