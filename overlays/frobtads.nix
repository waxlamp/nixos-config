final: prev: {
  frobtads = final.stdenv.mkDerivation {
    name = "frobtads-2.0";
    src = final.fetchFromGitHub {
      owner = "realnc";
      repo = "frobtads";
      rev = "v2.0";
      sha256 = "sha256-rSQn95sg/RlYakLINay42SWoRnh381iXgCxk0ksYvWw=";
    };
    nativeBuildInputs = with final.pkgs; [
      cmake
    ];
    buildInputs = with final.pkgs; [
      ncurses.dev
      curl.dev
    ];
    configurePhase = ''
      cmake .
    '';
    installPhase = ''
      mkdir -p $out/bin
      mv frob $out/bin
    '';
  };
}
