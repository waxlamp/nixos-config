{ nixpkgs, ... }:

{
  sound = {
    enable = true;
  };

  hardware.pulseaudio = {
    enable = true;

    # The full package includes bluetooth support.
    package = nixpkgs.pulseaudioFull;
  };
}
