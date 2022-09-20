{ nixpkgs, ... }:

{
  environment.shells = [
    nixpkgs.zsh
  ];

  users.users = {
    roni = {
      name = "roni";
      isNormalUser = true;
      group = "users";
      extraGroups = [
        "wheel"
        "vboxusers"
        "docker"
        "networkmanager"
      ];
      uid = 1000;
      home = "/home/roni";
      shell = nixpkgs.zsh;
      packages = with nixpkgs; [];
    };
  };
}
