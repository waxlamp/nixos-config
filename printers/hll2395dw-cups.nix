{ stdenv, fetchurl, makeWrapper
, cups
, dpkg
, a2ps, ghostscript, gnugrep, gnused, coreutils, file, perl, which
}:

stdenv.mkDerivation rec {
  name = "hll2395dw-cups-${version}";
  version = "4.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103564/hll2395dwpdrv-4.0.0-1.i386.deb";
    sha256 = "18zy039liqrh0wykays0b4np9mjfy233s8il0d9njbiwl7nnz9p2";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  unpackPhase = ":";

  installPhase = ''
    dpkg-deb -x $src $out

    substituteInPlace $out/opt/brother/Printers/HLL2395DW/cupswrapper/brother-HLL2395DW-cups-en.ppd \
      --replace '"Brother HLL2395DW' '"Brother HLL2395DW (modified)'

    substituteInPlace $out/opt/brother/Printers/HLL2395DW/lpd/lpdfilter \
      --replace /opt "$out/opt" \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HLL2395DW\"; #"

    # FIXME : Allow i686 and armv7l variations to be setup instead.
    _PLAT=x86_64
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2395DW/lpd/$_PLAT/brprintconflsr3
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2395DW/lpd/$_PLAT/rawtobr3
    ln -s $out/opt/brother/Printers/HLL2395DW/lpd/$_PLAT/brprintconflsr3 $out/opt/brother/Printers/HLL2395DW/lpd/brprintconflsr3
    ln -s $out/opt/brother/Printers/HLL2395DW/lpd/$_PLAT/rawtobr3 $out/opt/brother/Printers/HLL2395DW/lpd/rawtobr3

    for f in \
      $out/opt/brother/Printers/HLL2395DW/cupswrapper/lpdwrapper \
      $out/opt/brother/Printers/HLL2395DW/cupswrapper/paperconfigml2 \
    ; do
      #substituteInPlace $f \
      wrapProgram $f \
        --prefix PATH : ${stdenv.lib.makeBinPath [
          coreutils ghostscript gnugrep gnused
        ]}
    done

    # Hack suggested by samueldr.
    sed -i"" "s;A4;Letter;g" $out/opt/brother/Printers/HLL2395DW/inf/brHLL2395DWrc

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/HLL2395DW/lpd/lpdfilter $out/lib/cups/filter/brother_lpdwrapper_HLL2390DW

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/HLL2395DW/cupswrapper/brother-HLL2395DW-cups-en.ppd $out/share/cups/model/

    wrapProgram $out/opt/brother/Printers/HLL2395DW/lpd/lpdfilter \
      --prefix PATH ":" ${ stdenv.lib.makeBinPath [ ghostscript a2ps file gnused gnugrep coreutils which ] }
    '';

  meta = with stdenv.lib; {
    homepage = "https://www.brother.com/";
    description = "Brother HL-L2395DW combined print driver";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };
}
