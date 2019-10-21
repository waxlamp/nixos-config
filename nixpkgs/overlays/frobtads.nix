self: super:

{
  frobtads = self.stdenv.mkDerivation {
    name = "frobtads-1.2.3";
    src = self.fetchurl {
      url = https://www.tads.org/frobtads/frobtads-1.2.3.tar.gz;
      sha256 = "88c6a987813d4be1420a1c697e99ecef4fa9dd9bc922be4acf5a3054967ee788";
    };
    buildInputs = with self.pkgs; [
      ncurses.dev
      curl.dev
    ];
    patches = [ ./frobtads/fix-pointer-type.patch ];
  };
}
