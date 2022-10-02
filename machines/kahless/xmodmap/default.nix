({ lib, nixpkgs, ... }: {
  options.xmodmap-config = lib.mkOption {
    type = lib.types.path;
  };

  config.xmodmap-config =
    let
      xmodmap-text = builtins.readFile ./xmodmaprc;
      xmodmap-file = nixpkgs.writeText "xmodmap-config" xmodmap-text;
    in
      xmodmap-file;
})
