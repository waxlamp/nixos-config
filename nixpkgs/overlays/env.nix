self: super:

let
  candelaPkgs = import (fetchTarball {
    url = https://github.com/NixOS/nixpkgs-channels/archive/14a9ca27e69e33ac8ffb708de08883f8079f954a.tar.gz;
    sha256 = "1grsq8mcpl88v6kz8dp0vsybr0wzfg4pvhamj42dpd3vgr93l2ib";
  }) {};
in {
  env = {
    candela = super.mkShell {
      name = "candela";

      buildInputs = with candelaPkgs; [
        cairo
        nodejs-9_x
        nodePackages_8_x.node-gyp
        nodePackages.lerna
        pkgconfig
      ];
    };
  };
}
